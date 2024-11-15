package com.sma.sma_coding_dev_flutter_sdk

import android.Manifest
import android.content.Context
import android.net.Uri
import android.provider.ContactsContract
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.text.TextUtils
import com.bestmafen.baseble.util.BleLog
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.PermissionUtils
import com.blankj.utilcode.util.ScreenUtils
import com.blankj.utilcode.util.Utils
import com.szabh.smable3.BleKey
import com.szabh.smable3.BleKeyFlag
import com.szabh.smable3.component.BleCache
import com.szabh.smable3.component.BleConnector
import com.szabh.smable3.entity.BleDeviceInfo
import com.szabh.smable3.entity.BleNotification
import com.szabh.smable3.entity.BleNotification2
import java.util.Date
import java.util.regex.Pattern

object IncomingCall {
    private const val TAG = "IncomingCall"

    val mUpdateInComingCall = false

    private var mPhoneState = -1

    /**
     * 避免重复注册，出现一些莫名其妙的问题
     */
    var isSetPhoneListener = false

    var mEnable = false

    // PhoneStateListener必须用成员变量保留其引用，如果使用本地变量或匿名类，将不会有效果。
    // 只需要调用TelephonyManager.listen和声明相应权限
    private val mPhoneStateListener = object : PhoneStateListener() {

        // 监听电话
        override fun onCallStateChanged(state: Int, phoneNumber: String?) {//这个参数要加上问号，不然有些手机直接报空参数异常
            if (!mEnable) return
            BleLog.d(
                "$TAG PhoneStateListener onCallStateChanged -> isAppForeground:${AppUtils.isAppForeground()} isScreenLock:${ScreenUtils.isScreenLock()} state=${getCallState(state)}" +
                        ", phoneNumber=$phoneNumber, $mPhoneState"
            )
            if (state == TelephonyManager.CALL_STATE_RINGING) {
                // android.Manifest.permission.READ_CALL_LOG权限未被允许
                //如果用户选择仅使用中允许读取来电,能正常使用,一但进入后台，就获取不到号码，永远为空
//                if (phoneNumber.isEmpty()) return
                if(BleCache.mSupportSMSQuickReply == BleDeviceInfo.SUPPORT_SMS_QUICK_REPLY_1 && !TextUtils.isEmpty(phoneNumber)){
                    handleIncomingCall2(phoneNumber ?: "")
                } else {
                    handleIncomingCall(phoneNumber ?: "")
                }
            } else if (state == TelephonyManager.CALL_STATE_IDLE) {
                handleInComingCall(1)
                if (mPhoneState == TelephonyManager.CALL_STATE_RINGING) {
                    if(BleCache.mSupportSMSQuickReply == BleDeviceInfo.SUPPORT_SMS_QUICK_REPLY_1 && !TextUtils.isEmpty(phoneNumber)) {
                        handleMissedCall2(phoneNumber ?: "")
                    } else {
                        handleMissedCall(phoneNumber ?: "")
                    }
                } else if (mPhoneState == TelephonyManager.CALL_STATE_OFFHOOK) {
                    handleEnd()
                }
            } else if (state == TelephonyManager.CALL_STATE_OFFHOOK) {
                handleInComingCall(0)
                if (mPhoneState == TelephonyManager.CALL_STATE_RINGING) {
                    handleEnd()
                }
            }
            mPhoneState = state
        }
    }

    // 监听电话
    fun setPhoneListener(context: Context, enable: Boolean) {
        mEnable = enable
        (context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager)?.run {
            if (!isSetPhoneListener && PermissionUtils.isGranted(
                    Manifest.permission.READ_CALL_LOG,
                    Manifest.permission.READ_PHONE_STATE
                )
            ) {
                try {
                    // TODO: 安卓12开始这里有变化，未来要改
                    listen(mPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                isSetPhoneListener = true
                BleLog.v("setPhoneListener -> isSetPhoneListener = $isSetPhoneListener")
            }
        }
    }

    private fun handleIncomingCall(phoneNumber: String) {
        BleLog.d("handleIncomingCall -> $phoneNumber")
        if (!BleConnector.isAvailable()) return
        var title: String = getContactNameForPhoneNumber2(phoneNumber)
        BleNotification(
            mCategory = BleNotification.CATEGORY_INCOMING_CALL,
            mTime = Date().time,
            mTitle = title,
            mContent = Utils.getApp().getString(R.string.incoming_call)
        ).let {
            BleLog.v("$TAG handleIncomingCall -> Send Notification = $it")
            BleConnector.sendObject(BleKey.NOTIFICATION, BleKeyFlag.UPDATE, it)
        }
    }

    /**
     * 支持快捷回复
     */
    private fun handleIncomingCall2(phoneNumber: String) {
        BleLog.d("handleIncomingCall2 -> $phoneNumber")
        if (!BleConnector.isAvailable()) return
        var title: String = getContactNameForPhoneNumber2(phoneNumber)
        BleNotification2(
            mCategory = BleNotification.CATEGORY_INCOMING_CALL,
            mTime = Date().time,
            mTitle = title,
            mPhone = phoneNumber,
            mContent = Utils.getApp().getString(R.string.incoming_call)
        ).let {
            BleLog.v("$TAG handleIncomingCall2 -> Send Notification2 = $it")
            BleConnector.sendObject(BleKey.NOTIFICATION2, BleKeyFlag.UPDATE, it)
        }
    }

    private fun handleEnd() {
        BleLog.d("handleEnd")
        BleNotification(
            mCategory = BleNotification.CATEGORY_INCOMING_CALL
        ).let {
            BleLog.v("$TAG handleEnd -> Send Notification = $it")
            BleConnector.sendObject(BleKey.NOTIFICATION, BleKeyFlag.DELETE, it)
        }
    }

    private fun handleInComingCall(value: Int) {
        if (mUpdateInComingCall) {
            BleLog.d("handleInComingCall value=$value")
            BleConnector.sendInt8(BleKey.INCOMING_CALL, BleKeyFlag.UPDATE, value)
        }
    }

    private fun handleMissedCall(phoneNumber: String) {
        BleLog.d("handleMissedCall -> $phoneNumber")
        var title: String = getContactNameForPhoneNumber2(phoneNumber)
        BleNotification(
            mCategory = BleNotification.CATEGORY_MESSAGE,
            mTime = Date().time,
            mPackage = BleNotification.PACKAGE_MISSED_CALL,
            mTitle = title,
            mContent = Utils.getApp().getString(R.string.missed_call)
        ).let {
            BleLog.v("$TAG handleMissedCall -> Send Notification = $it")
            BleConnector.sendObject(BleKey.NOTIFICATION, BleKeyFlag.UPDATE, it)
        }
    }

    /**
     * 支持快捷回复
     */
    private fun handleMissedCall2(phoneNumber: String) {
        BleLog.d("handleMissedCall2 -> $phoneNumber")
        var title: String = getContactNameForPhoneNumber2(phoneNumber)
        BleNotification2(
            mCategory = BleNotification.CATEGORY_MESSAGE,
            mTime = Date().time,
            mPackage = BleNotification.PACKAGE_MISSED_CALL,
            mTitle = title,
            mPhone = phoneNumber,
            mContent = Utils.getApp().getString(R.string.missed_call)
        ).let {
            BleLog.v("$TAG handleMissedCall2 -> Send Notification2 = $it")
            BleConnector.sendObject(BleKey.NOTIFICATION2, BleKeyFlag.UPDATE, it)
        }
    }

    /**
     * 根据号码查询电话本中的联系人名称，如果查不到则返回该号码，如果有多个联系人名，返回的联系人名可能与系统来电显示的不一致
     */
    private fun getContactNameForPhoneNumber1(phoneNumber: String): String {
        if (!PermissionUtils.isGranted(android.Manifest.permission.READ_CONTACTS))
            return replacePhoneSpecialChar(phoneNumber)

        try {
            Utils.getApp().contentResolver.query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI, // uri
                arrayOf(
                    ContactsContract.PhoneLookup.DISPLAY_NAME,
                    ContactsContract.CommonDataKinds.Phone.NORMALIZED_NUMBER
                ), // projection
                ContactsContract.CommonDataKinds.Phone.NORMALIZED_NUMBER + " like '%$phoneNumber'", // selection
                null, null
            )?.use {
                if (it.moveToNext()) {
                    return replaceContactNameSpecialChar(it.getString(it.getColumnIndex(
                        ContactsContract.PhoneLookup.DISPLAY_NAME)))
                }
            }
            return replacePhoneSpecialChar(phoneNumber)
        } catch (e: Exception) {
            e.printStackTrace()
            return replacePhoneSpecialChar(phoneNumber)
        }
    }

    /**
     * 这个方法比较接近系统来电时通过手机号查询联系人名的方式，有多个联系人名则获取第一个，这样可以降低联系人名与系统提示的联系人名不一致的情况
     */
    private fun getContactNameForPhoneNumber2(phoneNumber: String): String {
        if (!PermissionUtils.isGranted(android.Manifest.permission.READ_CONTACTS))
            return replacePhoneSpecialChar(phoneNumber)

        try {
            Utils.getApp().contentResolver.query(
                Uri.withAppendedPath(
                    ContactsContract.PhoneLookup.CONTENT_FILTER_URI,
                    Uri.encode(phoneNumber)
                ), // uri
                null, null, null, null
            )?.use {
                if (it.moveToNext()) {
                    return replaceContactNameSpecialChar(it.getString(it.getColumnIndex(
                        ContactsContract.Data.DISPLAY_NAME)))
                }
            }
            return getContactNameForPhoneNumber1(phoneNumber)
        } catch (e: Exception) {
            e.printStackTrace()
            return replacePhoneSpecialChar(phoneNumber)
        }
    }

    private fun getCallState(state: Int) =
        when (state) {
            TelephonyManager.CALL_STATE_IDLE -> "IDLE"
            TelephonyManager.CALL_STATE_RINGING -> "RINGING"
            TelephonyManager.CALL_STATE_OFFHOOK -> "OFFHOOK"
            else -> "UNKNOWN"
        }

    /**
     * 替换联系人名称里的特殊字符
     */
    fun replaceContactNameSpecialChar(text: String): String {
        return Pattern
            .compile("[\\-]")
            .matcher(text).replaceAll("")
    }

    /**
     * 替换手机号里的特殊字符
     */
    fun replacePhoneSpecialChar(text: String): String {
        return Pattern
            .compile("[\\-\\s]")
            .matcher(text).replaceAll("")
    }
}