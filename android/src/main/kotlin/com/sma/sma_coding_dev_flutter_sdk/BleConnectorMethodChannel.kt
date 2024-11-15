package com.sma.sma_coding_dev_flutter_sdk

import android.Manifest
import android.app.Application
import android.bluetooth.BluetoothDevice
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioManager
import android.media.session.MediaSessionManager
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.service.notification.NotificationListenerService
import android.telecom.TelecomManager
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.text.TextUtils
import android.view.KeyEvent
import androidx.core.app.ActivityCompat
import com.bestmafen.baseble.data.BleBuffer
import com.bestmafen.baseble.data.mHexString
import com.bestmafen.baseble.util.BleLog
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.FileUtils
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.PathUtils
import com.blankj.utilcode.util.PermissionUtils
import com.blankj.utilcode.util.ScreenUtils
import com.blankj.utilcode.util.ThreadUtils
import com.blankj.utilcode.util.Utils
import com.szabh.smable3.BleKey
import com.szabh.smable3.BleKeyFlag
import com.szabh.smable3.component.BleCache
import com.szabh.smable3.component.BleConnector
import com.szabh.smable3.component.BleHandleCallback
import com.szabh.smable3.entity.*
import com.szabh.smable3.music.MyState
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap
import kotlin.math.ceil

class BleConnectorMethodChannel constructor(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    channelName: String
) : BaseMethodChannel(flutterPluginBinding, channelName), MethodChannel.MethodCallHandler, BaseOTAManager.OTACallback {
    private val TAG = "BleConnectorMethodChannel"

    private var mOTAManager: BaseOTAManager? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = if (call.arguments != null) call.arguments as JSONObject else null
        BleLog.d("$TAG -> onMethodCall ${call.method} $param")
        try {
            when (call.method) {
                SdkMethod.init -> {
                    init(param, call.method, result)
                }
                SdkMethod.sendData -> {
                    sendData(param, call.method, result)
                }
                SdkMethod.sendInt8 -> {
                    sendInt8(param, call.method, result)
                }
                SdkMethod.sendInt16 -> {
                    sendInt16(param, call.method, result)
                }
                SdkMethod.sendInt32 -> {
                    sendInt32(param, call.method, result)
                }
                SdkMethod.sendBoolean -> {
                    sendBoolean(param, call.method, result)
                }
                SdkMethod.sendObject -> {
                    sendObject(param, call.method, result)
                }
                SdkMethod.sendStream -> {
                    sendStream(param, call.method, result)
                }
                SdkMethod.connectClassic -> {
                    connectClassic(param, call.method, result)
                }
                SdkMethod.launch -> {
                    launch(param, call.method, result)
                }
                SdkMethod.unbind -> {
                    unbind(param, call.method, result)
                }
                SdkMethod.isBound -> {
                    isBound(param, call.method, result)
                }
                SdkMethod.isAvailable -> {
                    isAvailable(param, call.method, result)
                }
                SdkMethod.setAddress -> {
                    setAddress(param, call.method, result)
                }
                SdkMethod.connect -> {
                    connect(param, call.method, result)
                }
                SdkMethod.closeConnection -> {
                    closeConnection(param, call.method, result)
                }
                SdkMethod.startOTA -> {
                    startOTA(param, call.method, result)
                }
                SdkMethod.releaseOTA -> {
                    releaseOTA(param, call.method, result)
                }
                SdkMethod.startMusicController -> {
                    startMusicController(param, call.method, result)
                }
                SdkMethod.stopMusicController -> {
                    stopMusicController(param, call.method, result)
                }
                SdkMethod.saveLogs -> {
                    saveLogs(param, call.method, result)
                }
                SdkMethod.setPhoneStateListener -> {
                    setPhoneStateListener(param, call.method, result)
                }
                SdkMethod.setDataKeyAutoDelete -> {
                    setDataKeyAutoDelete(param, call.method, result)
                }
                SdkMethod.isConnecting -> {
                    isConnecting(param, call.method, result)
                }
                SdkMethod.isMusicControllerRunning -> {
                    isMusicControllerRunning(param, call.method, result)
                }
                SdkMethod.sendMusicPlayState -> {
                    sendMusicPlayState(param, call.method, result)
                }
                SdkMethod.sendMusicTitle -> {
                    sendMusicTitle(param, call.method, result)
                }
                SdkMethod.sendPhoneVolume -> {
                    sendPhoneVolume(param, call.method, result)
                }
                else -> {
                    super.onMethodCall(call, result)
                }
            }
        } catch (ignored: JSONException) {
        }
    }

    @Throws(JSONException::class)
    private fun sendData(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        when(bleKey){
            BleKey.TIME.mKey -> BleConnector.sendObject(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), BleTime.local())
            BleKey.TIME_ZONE.mKey ->  BleConnector.sendObject(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), BleTimeZone())
            else -> BleConnector.sendData(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag))
        }
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendInt8(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        val value = param?.getInt("value") ?: 0
        BleConnector.sendInt8(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), value)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendInt16(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        val value = param?.getInt("value") ?: 0
        BleConnector.sendInt16(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), value)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendInt32(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        val value = param?.getInt("value") ?: 0
        BleConnector.sendInt32(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), value)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendBoolean(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        val value = param?.getBoolean("value") ?: false
        BleConnector.sendBoolean(BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), value)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendObject(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val bleKeyFlag = param?.getInt("bleKeyFlag") ?: BleKeyFlag.NONE.mBleKeyFlag
        val value = param?.getJSONObject("value")
        if (value != null) {
            when(BleKey.of(bleKey)) {
                BleKey.CONTACT -> {
                    val addressBook = value.getJSONArray("addressBook")
                    //固件拟定:姓名 24和电话号码 16个字节,所以此处依据数据大小,创建array
                    val bytes = ByteArray(addressBook.length() * 40)
                    for (i in 0 until addressBook.length()) {
                        val obj = addressBook.getJSONObject(i)
                        LogUtils.d("${obj.getString("userName")} ${obj.getString("userPhone")}")

                        val nameBytes = obj.getString("userName").toByteArray()
                        for (valueIndex in nameBytes.indices) {
                            if (valueIndex < 24) {
                                bytes[i * 40 + valueIndex] = nameBytes[valueIndex]
                            }
                        }
                        val phoneBytes = obj.getString("userPhone").toByteArray()
                        for (valueIndex in phoneBytes.indices) {
                            if (valueIndex < 16) {
                                bytes[i * 40 + 24 + valueIndex] = phoneBytes[valueIndex]
                            }
                        }
                    }
                    LogUtils.d(bytes.mHexString)
                    BleConnector.sendStream(BleKey.CONTACT, bytes)
                }
                BleKey.WATCH_FACE -> {
                    BleConnector.sendStream(BleKey.WATCH_FACE, WatchFaceUtils.genWatchFaceBin(value))
                }
                else -> {
                    BleConnector.sendObject(
                        BleKey.of(bleKey),
                        BleKeyFlag.of(bleKeyFlag),
                        getObject(BleKey.of(bleKey), value)
                    )
                }
            }
        }
        onResult(result, channelName, true)
    }

    private fun getObject(bleKey: BleKey, json: JSONObject): BleBuffer? {
        return when (bleKey) {
            BleKey.USER_PROFILE -> BleUserProfileHelper.fromJson(json)
            BleKey.SEDENTARINESS -> BleSedentarinessSettingsHelper.fromJson(json)
            BleKey.NO_DISTURB_RANGE -> BleNoDisturbSettingsHelper.fromJson(json)
            BleKey.GESTURE_WAKE -> BleGestureWakeHelper.fromJson(json)
            BleKey.ALARM -> BleAlarmHelper.fromJson(json)
            BleKey.GIRL_CARE -> BleGirlCareSettingsHelper.fromJson(json)
            BleKey.SCHEDULE -> BleScheduleHelper.fromJson(json)
            BleKey.NOTIFICATION -> BleNotificationHelper.fromJson(json)
            BleKey.WEATHER_FORECAST -> BleWeatherForecastHelper.fromJson(json)
            BleKey.WEATHER_REALTIME -> BleWeatherRealtimeHelper.fromJson(json)
            BleKey.LOVE_TAP_USER -> BleLoveTapUserHelper.fromJson(json)
            BleKey.LOVE_TAP -> BleLoveTapHelper.fromJson(json)
            BleKey.MEDICATION_REMINDER -> BleMedicationReminderHelper.fromJson(json)
            BleKey.NEWS_FEED -> BleNewsFeedHelper.fromJson(json)
            BleKey.HR_WARNING_SET -> BleHrWarningSettingsHelper.fromJson(json)
            BleKey.SLEEP_MONITORING -> BleSleepMonitoringSettingsHelper.fromJson(json)
            BleKey.WEATHER_FORECAST2 -> BleWeatherForecast2Helper.fromJson(json)
            BleKey.WEATHER_REALTIME2 -> BleWeatherRealtime2Helper.fromJson(json)
            BleKey.HR_MONITORING -> BleHrMonitoringSettingsHelper.fromJson(json)
            BleKey.DRINK_WATER -> BleDrinkWaterSettingsHelper.fromJson(json)
            else -> null
        }
    }

    @Throws(JSONException::class)
    private fun sendStream(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val bleKey: Int = param?.getInt("bleKey") ?: BleKey.NONE.mKey
        val value = param?.getString("value")
        BleConnector.sendStream(BleKey.of(bleKey), File(value))
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun connectClassic(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        BleConnector.connectClassic()
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun launch(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        BleConnector.launch()
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun unbind(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        BleConnector.unbind()
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun isBound(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        onResult(result, channelName, BleConnector.isBound())
    }

    @Throws(JSONException::class)
    private fun isAvailable(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        onResult(result, channelName, BleConnector.isAvailable())
    }

    @Throws(JSONException::class)
    private fun setAddress(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val address = param?.getString("address") ?: ""
        BleConnector.setAddress(address)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun connect(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val connect = param?.getBoolean("connect") ?: true
        BleConnector.connect(connect)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun closeConnection(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val stopReconnecting = param?.getBoolean("stopReconnecting") ?: true
        BleConnector.closeConnection(stopReconnecting)
        onResult(result, channelName, true)
    }

    override fun onOTAProgress(progress: Double, otaStatus: Int, error: String) {
        val data: MutableMap<String, Any> = HashMap()
        data["progress"] = progress
        data["otaStatus"] = otaStatus
        data["error"] = error
        post { channel.invokeMethod(SdkMethod.onOTAProgress, data) }
    }

    @Throws(JSONException::class)
    private fun startOTA(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        param?.getString("filePath")?.let {
            val platform = param.getString("platform")
            mOTAManager = when (if (TextUtils.isEmpty(platform)) BleCache.mPlatform else platform) {
                BleDeviceInfo.PLATFORM_JL -> {
                    //杰里有升级失败的概率，没退出ota前不要重复初始化
                    if (mOTAManager == null) {
                        JOTAManager(this.context, this)
                    } else mOTAManager
                }
                else -> {
                    // TODO: 默认用瑞昱，后续有调整再优化
                    ROTAManager(this.context, this)
                }
            }
            mOTAManager?.startOTA(it, param.getString("address"), param.getBoolean("isDfu"))
        }
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun releaseOTA(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        mOTAManager?.releaseOTA()
        mOTAManager = null
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun startMusicController(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        MusicManager.startMusicController(this.context)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun stopMusicController(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        MusicManager.stopMusicController()
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun saveLogs(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val isSave = param?.getBoolean("isSave") ?: false
        if (isSave && BleLog.mInterceptor == null) {
            BleLog.mInterceptor = { level, _, msg ->
                ThreadUtils.executeBySingle(object : ThreadUtils.SimpleTask<Void?>() {
                    private val LOG_LINE_LENGTH = 140
                    override fun doInBackground(): Void? {
                        val date = Date()
                        val fileName =
                            SimpleDateFormat(
                                "yyyyMMdd",
                                Locale.getDefault()
                            ).format(date) + ".txt"
                        val time =
                            SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(date)
                        val lines = ceil(msg.length.toDouble() / LOG_LINE_LENGTH).toInt()
                        repeat(lines) {
                            val content = if (it == lines - 1) {
                                msg.substring(it * LOG_LINE_LENGTH, msg.length)
                            } else {
                                msg.substring(it * LOG_LINE_LENGTH, (it + 1) * LOG_LINE_LENGTH)
                            }
                            File(
                                PathUtils.getExternalAppDataPath() + "/files/ble_logs",
                                fileName
                            ).also { file ->
                                FileUtils.createOrExistsFile(file)
                            }.appendText("$time $level $content\n")
                        }
                        return null
                    }

                    override fun onSuccess(result: Void?) {
                    }
                })
                false
            }
        } else {
            BleLog.mInterceptor = null
        }
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun setPhoneStateListener(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val enable = param?.getBoolean("enable") ?: true
        IncomingCall.setPhoneListener(context.applicationContext, enable)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun setDataKeyAutoDelete(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val isAutoDelete = param?.getBoolean("isAutoDelete") ?: true
        BleConnector.setDataKeyAutoDelete(isAutoDelete)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun isConnecting(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        onResult(result, channelName, BleConnector.isConnecting)
    }

    @Throws(JSONException::class)
    private fun isMusicControllerRunning(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        onResult(result, channelName, MusicManager.isMusicControllerRunning())
    }

    @Throws(JSONException::class)
    private fun sendMusicPlayState(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val state = param?.getInt("state") ?: 0
        if (state == PlaybackState.PLAYING.mState.toInt()) {
            val contents = listOf("${MyState.PLAYING.mState}", String.format("%.1f", 0f), ",0")
            BleConnector.updateMusic(BleMusicControl(MusicEntity.PLAYER, MusicAttr.PLAYER_PLAYBACK_INFO, contents))
        } else if (state == PlaybackState.PAUSED.mState.toInt()) {
            val contents = listOf("${MyState.PAUSED.mState}", String.format("%.1f", 0f), ",0")
            BleConnector.updateMusic(BleMusicControl(MusicEntity.PLAYER, MusicAttr.PLAYER_PLAYBACK_INFO, contents))
        }
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendMusicTitle(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val title = param?.getString("title") ?: " "
        BleConnector.sendObject(
            BleKey.MUSIC_CONTROL, BleKeyFlag.UPDATE,
            BleMusicControl(MusicEntity.TRACK, MusicAttr.TRACK_TITLE, title)
        )
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendMusicArtist(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val artist = param?.getString("artist") ?: " "
        BleConnector.sendObject(
            BleKey.MUSIC_CONTROL, BleKeyFlag.UPDATE,
            BleMusicControl(MusicEntity.TRACK, MusicAttr.TRACK_ARTIST, artist)
        )
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun sendPhoneVolume(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val volume = param?.getInt("volume") ?: 0
        val value = keepTwoDecimal(volume / 100f)
        BleConnector.updateMusic(
            BleMusicControl(MusicEntity.PLAYER, MusicAttr.PLAYER_VOLUME, value)
        )
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun init(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        Utils.init(context.applicationContext as Application)
        BleScannerMethodChannel(binging,"ble_scanner")

        val connector = BleConnector.Builder(context.applicationContext)
//            .supportNordicOta(true)
            .supportRealtekDfu(true) // 是否支持Realtek设备Dfu，如果不需要支持传false。
//            .supportMtkOta(true) // 是否支持MTK设备Ota，如果不需要支持传false。
            .supportLauncher(true) // 是否支持自动连接Ble蓝牙设备方法（如果绑定的话），如果不需要请传false
            .supportFilterEmpty(true) // 是否支持过滤空数据，如ACTIVITY、HEART_RATE、BLOOD_PRESSURE、SLEEP、WORKOUT、LOCATION、TEMPERATURE、BLOOD_OXYGEN、HRV，如果不需要支持传false。
            .build()

        connector.addHandleCallback(object : BleHandleCallback {
            override fun onAlarmAdd(alarm: BleAlarm) {
                post { channel.invokeMethod(SdkMethod.onAlarmAdd, BleAlarmHelper.toJson(alarm)) }
            }

            override fun onAlarmDelete(id: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["id"] = id
                post { channel.invokeMethod(SdkMethod.onAlarmDelete, data) }
            }

            override fun onAlarmUpdate(alarm: BleAlarm) {
                post { channel.invokeMethod(SdkMethod.onAlarmUpdate, BleAlarmHelper.toJson(alarm)) }
            }

            override fun onAppSportDataResponse(status: Boolean) {
            }

            override fun onCameraResponse(status: Boolean, cameraState: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                data["cameraState"] = cameraState
                post { channel.invokeMethod(SdkMethod.onCameraResponse, data) }
            }

            override fun onCameraStateChange(cameraState: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["cameraState"] = cameraState
                post { channel.invokeMethod(SdkMethod.onCameraStateChange, data) }
            }

            override fun onClassicBluetoothStateChange(state: Int) {
            }

            override fun onCommandReply(bleKey: BleKey, bleKeyFlag: BleKeyFlag, status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["bleKey"] = bleKey.mKey
                data["bleKeyFlag"] = bleKeyFlag.mBleKeyFlag
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onCommandReply, data) }
            }

            override fun onCommandSendTimeout(bleKey: BleKey, bleKeyFlag: BleKeyFlag) {
                val data: MutableMap<String, Any> = HashMap()
                data["bleKey"] = bleKey.mKey
                data["bleKeyFlag"] = bleKeyFlag.mBleKeyFlag
                post { channel.invokeMethod(SdkMethod.onCommandSendTimeout, data) }
            }

            override fun onDeviceConnected(device: BluetoothDevice) {
                val data: MutableMap<String, Any> = HashMap()
                data["mName"] = device.name ?: "" //有可能为空，造成闪退
                data["mAddress"] = device.address
                data["mRssi"] = 0
                post { channel.invokeMethod(SdkMethod.onDeviceConnected, data) }
            }

            override fun onDeviceConnecting(status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onDeviceConnecting, data) }
            }

            override fun onDeviceFileUpdate(deviceFile: BleDeviceFile) {
            }

            override fun onDeviceRequestAGpsFile(url: String) {
                val data: MutableMap<String, Any> = HashMap()
                data["url"] = url
                post { channel.invokeMethod(SdkMethod.onDeviceRequestAGpsFile, data) }
            }

            override fun onFindPhone(start: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["start"] = start
                post { channel.invokeMethod(SdkMethod.onFindPhone, data) }
            }

            override fun onFollowSystemLanguage(status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onFollowSystemLanguage, data) }
            }

            override fun onHIDState(state: Int) {
            }

            override fun onHIDValueChange(value: Int) {
            }

            override fun onIdentityCreate(status: Boolean, deviceInfo: BleDeviceInfo?) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                if (deviceInfo != null) {
                    data["deviceInfo"] = BleDeviceInfoHelper.toJson(deviceInfo)
                }
                post { channel.invokeMethod(SdkMethod.onIdentityCreate, data) }
            }

            override fun onIdentityDelete(status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onIdentityDelete, data) }
            }

            override fun onIdentityDeleteByDevice(isDevice: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["isDevice"] = isDevice
                post { channel.invokeMethod(SdkMethod.onIdentityDeleteByDevice, data) }
            }

            override fun onIncomingCallStatus(status: Int) {
                if (status == 0) {
                    //接听电话
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            if (ActivityCompat.checkSelfPermission(
                                    Utils.getApp(),
                                    Manifest.permission.ANSWER_PHONE_CALLS
                                ) != PackageManager.PERMISSION_GRANTED
                            ) {
                                return
                            }
                            val manager =
                                Utils.getApp().getSystemService(Context.TELECOM_SERVICE) as TelecomManager?
                            manager?.acceptRingingCall()
                        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                            val mediaSessionManager =
                                Utils.getApp().getSystemService(Context.MEDIA_SESSION_SERVICE) as MediaSessionManager
                            val mediaControllerList = mediaSessionManager.getActiveSessions(getNotificationListener(Utils.getApp()))
                            for (m in mediaControllerList) {
                                if ("com.android.server.telecom" == m.packageName) {
                                    m.dispatchMediaButtonEvent(
                                        KeyEvent(
                                            KeyEvent.ACTION_DOWN,
                                            KeyEvent.KEYCODE_HEADSETHOOK
                                        )
                                    )
                                    m.dispatchMediaButtonEvent(
                                        KeyEvent(
                                            KeyEvent.ACTION_UP,
                                            KeyEvent.KEYCODE_HEADSETHOOK
                                        )
                                    )
                                    break
                                }
                            }
                        } else {
                            val audioManager =
                                Utils.getApp().getSystemService(Context.AUDIO_SERVICE) as AudioManager?
                            val eventDown = KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_HEADSETHOOK)
                            val eventUp = KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_HEADSETHOOK)
                            audioManager?.dispatchMediaKeyEvent(eventDown)
                            audioManager?.dispatchMediaKeyEvent(eventUp)
                            Runtime.getRuntime()
                                .exec("input keyevent " + Integer.toString(KeyEvent.KEYCODE_HEADSETHOOK))
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                } else {
                    //拒接
                    if (Build.VERSION.SDK_INT < 28) {
                        try {
                            val telephonyClass =
                                Class.forName("com.android.internal.telephony.ITelephony")
                            val telephonyStubClass = telephonyClass.classes[0]
                            val serviceManagerClass = Class.forName("android.os.ServiceManager")
                            val serviceManagerNativeClass =
                                Class.forName("android.os.ServiceManagerNative")
                            val getService =
                                serviceManagerClass.getMethod("getService", String::class.java)
                            val tempInterfaceMethod =
                                serviceManagerNativeClass.getMethod("asInterface", IBinder::class.java)
                            val tmpBinder = Binder()
                            tmpBinder.attachInterface(null, "fake")
                            val serviceManagerObject = tempInterfaceMethod.invoke(null, tmpBinder)
                            val retbinder = getService.invoke(serviceManagerObject, "phone") as IBinder
                            val serviceMethod =
                                telephonyStubClass.getMethod("asInterface", IBinder::class.java)
                            val telephonyObject = serviceMethod.invoke(null, retbinder)
                            val telephonyEndCall = telephonyClass.getMethod("endCall")
                            telephonyEndCall.invoke(telephonyObject)
                        } catch (e: Exception) {
                            LogUtils.d("hang up error " + e.printStackTrace())
                        }
                    } else {
                        if (ActivityCompat.checkSelfPermission(
                                Utils.getApp(),
                                Manifest.permission.ANSWER_PHONE_CALLS
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            return
                        }
                        LogUtils.d("hang up OK")
                        val manager = Utils.getApp().getSystemService(Context.TELECOM_SERVICE) as TelecomManager
                        manager.endCall()
                    }
                }

                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onIncomingCallStatus, data) }
            }

            override fun onOTA(status: Boolean) {
            }

            override fun onReadActivity(activities: List<BleActivity>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleActivityHelper.listToJson(activities)
                post { channel.invokeMethod(SdkMethod.onReadActivity, data) }
            }

            override fun onReadAlarm(alarms: List<BleAlarm>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleAlarmHelper.listToJson(alarms)
                post { channel.invokeMethod(SdkMethod.onReadAlarm, data) }
            }

            override fun onReadBleHrv(hrv: List<BleHrv>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleHrvHelper.listToJson(hrv)
                post { channel.invokeMethod(SdkMethod.onReadBleHrv, data) }
            }

            override fun onReadBleLogText(logs: List<BleLogText>) {
            }

            override fun onReadBloodOxygen(bloodOxygen: List<BleBloodOxygen>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleBloodOxygenHelper.listToJson(bloodOxygen)
                post { channel.invokeMethod(SdkMethod.onReadBloodOxygen, data) }
            }

            override fun onReadBloodPressure(bloodPressures: List<BleBloodPressure>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleBloodPressureHelper.listToJson(bloodPressures)
                post { channel.invokeMethod(SdkMethod.onReadBloodPressure, data) }
            }

            override fun onReadCoachingIds(bleCoachingIds: BleCoachingIds) {
            }

            override fun onReadDateFormat(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onReadDateFormat, data) }
            }

            override fun onReadDeviceFile(deviceFile: BleDeviceFile) {
            }

            override fun onReadDrinkWater(drinkWaterSettings: BleDrinkWaterSettings) {
            }

            override fun onReadFirmwareVersion(version: String) {
                val data: MutableMap<String, Any> = HashMap()
                data["version"] = version
                post { channel.invokeMethod(SdkMethod.onReadFirmwareVersion, data) }
            }

            override fun onReadHeartRate(heartRates: List<BleHeartRate>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleHeartRateHelper.listToJson(heartRates)
                post { channel.invokeMethod(SdkMethod.onReadHeartRate, data) }
            }

            override fun onReadLanguagePackVersion(version: BleLanguagePackVersion) {
                post { channel.invokeMethod(SdkMethod.onReadLanguagePackVersion, BleLanguagePackVersionHelper.toJson(version)) }
            }

            override fun onReadLocation(locations: List<BleLocation>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleLocationHelper.listToJson(locations)
                post { channel.invokeMethod(SdkMethod.onReadLocation, data) }
            }

            override fun onReadMatchRecord(matchRecords: List<BleMatchRecord>) {
            }

            override fun onReadMtkOtaMeta() {
            }

            override fun onReadNoDisturb(noDisturbSettings: BleNoDisturbSettings) {
                post { channel.invokeMethod(SdkMethod.onReadNoDisturb, BleNoDisturbSettingsHelper.toJson(noDisturbSettings)) }
            }

            override fun onNoDisturbUpdate(noDisturbSettings: BleNoDisturbSettings) {
                post { channel.invokeMethod(SdkMethod.onNoDisturbUpdate, BleNoDisturbSettingsHelper.toJson(noDisturbSettings)) }
            }

            override fun onReadPower(power: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["power"] = power
                post { channel.invokeMethod(SdkMethod.onReadPower, data) }
            }

            override fun onReadPressure(pressures: List<BlePressure>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BlePressureHelper.listToJson(pressures)
                post { channel.invokeMethod(SdkMethod.onReadPressure, data) }
            }

            override fun onReadSedentariness(sedentarinessSettings: BleSedentarinessSettings) {
                post { channel.invokeMethod(SdkMethod.onReadSedentariness, BleSedentarinessSettingsHelper.toJson(sedentarinessSettings)) }
            }

            override fun onReadSleep(sleeps: List<BleSleep>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleSleepHelper.listToJson(sleeps)
                post { channel.invokeMethod(SdkMethod.onReadSleep, data) }
            }

            override fun onReadSleepQuality(sleepQuality: BleSleepQuality) {
            }

            override fun onReadSleepRaw(sleepRawData: ByteArray) {
            }

            override fun onReadTemperature(temperatures: List<BleTemperature>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleTemperatureHelper.listToJson(temperatures)
                post { channel.invokeMethod(SdkMethod.onReadTemperature, data) }
            }

            override fun onReadTemperatureUnit(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onReadTemperatureUnit, data) }
            }

            override fun onReadUiPackVersion(version: String) {
                val data: MutableMap<String, Any> = HashMap()
                data["version"] = version
                post { channel.invokeMethod(SdkMethod.onReadUiPackVersion, data) }
            }

            override fun onReadWatchFaceId(watchFaceId: BleWatchFaceId) {
            }

            override fun onReadWatchFaceSwitch(value: Int) {
            }

            override fun onReadWeatherRealTime(status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onReadWeatherRealTime, data) }
            }

            override fun onReadWorkout(workouts: List<BleWorkout>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleWorkoutHelper.listToJson(workouts)
                post { channel.invokeMethod(SdkMethod.onReadWorkout, data) }
            }

            override fun onReadWorkout2(workouts: List<BleWorkout2>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleWorkout2Helper.listToJson(workouts)
                post { channel.invokeMethod(SdkMethod.onReadWorkout2, data) }
            }

            override fun onReceiveGSensorMotion(gSensorMotions: List<BleGSensorMotion>) {
            }

            override fun onReceiveGSensorRaw(gSensorRaws: List<BleGSensorRaw>) {
            }

            override fun onReceiveLocationGga(locationGga: BleLocationGga) {
            }

            override fun onReceiveMusicCommand(musicCommand: MusicCommand) {
                val data: MutableMap<String, Any> = HashMap()
                data["musicCommand"] = musicCommand.mCommand.toInt()
                post { channel.invokeMethod(SdkMethod.onReceiveMusicCommand, data) }
            }

            override fun onReceiveRealtimeLog(realtimeLog: BleRealtimeLog) {
            }

            override fun onRequestAgpsPrerequisite() {
            }

            override fun onRequestLocation(workoutState: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["workoutState"] = workoutState
                post { channel.invokeMethod(SdkMethod.onRequestLocation, data) }
            }

            override fun onReadBleAddress(address: String) {
                val data: MutableMap<String, Any> = HashMap()
                data["address"] = address
                post { channel.invokeMethod(SdkMethod.onReadBleAddress, data) }
            }

            override fun onSessionStateChange(status: Boolean) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                post { channel.invokeMethod(SdkMethod.onSessionStateChange, data) }
            }

            override fun onStreamProgress(
                status: Boolean,
                errorCode: Int,
                total: Int,
                completed: Int,
                bleKey: BleKey
            ) {
                val data: MutableMap<String, Any> = HashMap()
                data["status"] = status
                data["errorCode"] = errorCode
                data["total"] = total
                data["completed"] = completed
                post { channel.invokeMethod(SdkMethod.onStreamProgress, data) }
            }

            override fun onSyncData(syncState: Int, bleKey: BleKey) {
                val data: MutableMap<String, Any> = HashMap()
                data["syncState"] = syncState
                data["bleKey"] = bleKey.mKey
                post { channel.invokeMethod(SdkMethod.onSyncData, data) }
            }

            override fun onUpdateAppSportState(appSportState: BleAppSportState) {
            }

            override fun onUpdateBloodPressure(bloodPressure: BleBloodPressure) {
            }

            override fun onUpdateHeartRate(heartRate: BleHeartRate) {
                post { channel.invokeMethod(SdkMethod.onUpdateHeartRate, BleHeartRateHelper.toJson(heartRate)) }
            }

            override fun onUpdateTemperature(temperature: BleTemperature) {
            }

            override fun onUpdateWatchFaceSwitch(status: Boolean) {
            }

            override fun onVibrationUpdate(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onVibrationUpdate, data) }
            }

            override fun onBacklightUpdate(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onBacklightUpdate, data) }
            }

            override fun onWatchFaceIdUpdate(status: Boolean) {
            }

            override fun onXModem(status: Byte) {
            }

            override fun onReadDeviceInfo(deviceInfo: BleDeviceInfo) {
                val data: MutableMap<String, Any> = HashMap()
                data["deviceInfo"] = BleDeviceInfoHelper.toJson(deviceInfo)
                post { channel.invokeMethod(SdkMethod.onReadDeviceInfo, data) }
            }

            override fun onReadGestureWake(gestureWake: BleGestureWake) {
                post { channel.invokeMethod(SdkMethod.onReadGestureWake, BleGestureWakeHelper.toJson(gestureWake)) }
            }

            override fun onGestureWakeUpdate(gestureWake: BleGestureWake) {
                post { channel.invokeMethod(SdkMethod.onGestureWakeUpdate, BleGestureWakeHelper.toJson(gestureWake)) }
            }

            override fun onPowerSaveModeState(state: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["state"] = state
                post { channel.invokeMethod(SdkMethod.onPowerSaveModeState, data) }
            }

            override fun onPowerSaveModeStateChange(state: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["state"] = state
                post { channel.invokeMethod(SdkMethod.onPowerSaveModeStateChange, data) }
            }

            override fun onReadLoveTapUser(loveTapUsers: List<BleLoveTapUser>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleLoveTapUserHelper.listToJson(loveTapUsers)
                post { channel.invokeMethod(SdkMethod.onReadLoveTapUser, data) }
            }

            override fun onLoveTapUserUpdate(loveTapUser: BleLoveTapUser) {
                post { channel.invokeMethod(SdkMethod.onLoveTapUserUpdate, BleLoveTapUserHelper.toJson(loveTapUser)) }
            }

            override fun onLoveTapUserDelete(id: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["id"] = id
                post { channel.invokeMethod(SdkMethod.onLoveTapUserDelete, data) }
            }

            override fun onReadMedicationReminder(medicationReminders: List<BleMedicationReminder>) {
                val data: MutableMap<String, Any> = HashMap()
                data["list"] = BleMedicationReminderHelper.listToJson(medicationReminders)
                post { channel.invokeMethod(SdkMethod.onReadMedicationReminder, data) }
            }

            override fun onMedicationReminderDelete(id: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["id"] = id
                post { channel.invokeMethod(SdkMethod.onMedicationReminderDelete, data) }
            }

            override fun onMedicationReminderUpdate(medicationReminder: BleMedicationReminder) {
                post { channel.invokeMethod(SdkMethod.onMedicationReminderUpdate, BleMedicationReminderHelper.toJson(medicationReminder)) }
            }

            override fun onLoveTapUpdate(loveTap: BleLoveTap) {
                post { channel.invokeMethod(SdkMethod.onLoveTapUpdate, BleLoveTapHelper.toJson(loveTap)) }
            }

            override fun onReadDeviceInfo2(deviceInfo: BleDeviceInfo2) {
                val data: MutableMap<String, Any> = HashMap()
                data["deviceInfo"] = BleDeviceInfo2Helper.toJson(deviceInfo)
                post { channel.invokeMethod(SdkMethod.onReadDeviceInfo2, data) }
            }

            override fun onReadUnit(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onReadUnit, data) }
            }

            override fun onReadHrMonitoringSettings(hrMonitoringSettings: BleHrMonitoringSettings) {
                post { channel.invokeMethod(SdkMethod.onReadHrMonitoringSettings, BleHrMonitoringSettingsHelper.toJson(hrMonitoringSettings)) }
            }

            override fun onReadBacklight(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onReadBacklight, data) }
            }

            override fun onReadHourSystem(value: Int) {
                val data: MutableMap<String, Any> = HashMap()
                data["value"] = value
                post { channel.invokeMethod(SdkMethod.onReadHourSystem, data) }
            }
        })

        onResult(result, channelName, true)
    }

    private fun getNotificationListener(context: Context): ComponentName {
        if (context !is NotificationListenerService) {
            val s = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SERVICES).services?.find {
                it.permission == "android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"
            }
            s?.let {
                LogUtils.d("NotificationListener -> ${s.name}")
                return ComponentName(context, s.name)
            }
        }
        return ComponentName(context, context::class.java)
    }
}