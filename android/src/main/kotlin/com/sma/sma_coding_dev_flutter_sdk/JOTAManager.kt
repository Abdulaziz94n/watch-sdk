package com.sma.sma_coding_dev_flutter_sdk

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.text.TextUtils
import com.bestmafen.baseble.util.BleLog
import com.blankj.utilcode.util.Utils
import com.jieli.jl_bt_ota.constant.StateCode
import com.jieli.jl_bt_ota.interfaces.BtEventCallback
import com.jieli.jl_bt_ota.interfaces.IUpgradeCallback
import com.jieli.jl_bt_ota.model.base.BaseError
import com.jieli.watchtesttool.tool.bluetooth.BluetoothEventListener
import com.jieli.watchtesttool.tool.bluetooth.BluetoothHelper
import com.jieli.watchtesttool.tool.upgrade.OTAManager
import com.szabh.smable3.component.BleCache

class JOTAManager(context: Context, callback: OTACallback) : BaseOTAManager(context, callback) {

    private val TAG = "JOTAManager"

    private var isUseDfuAddress = false

    private var mBluetoothHelper:BluetoothHelper? = null

    private val mBtEventListener = object : BluetoothEventListener() {
        override fun onAdapterStatus(bEnabled: Boolean) {
            BleLog.d("$TAG bt onAdapterStatus $bEnabled")
            if(!bEnabled){
                updateOtaStatus(OTAStatus.OTA_FAILED, error = "Bluethooth disable")
            }
        }
        override fun onConnection(device: BluetoothDevice, status: Int) {
            BleLog.d("$TAG bt onConnection $device $status")
        }
    }

    private val mOTAEventCallback: BtEventCallback = object : BtEventCallback() {
        override fun onConnection(device: BluetoothDevice, status: Int) {
            BleLog.d("$TAG ota onConnection -> mOtaStatus = $mOtaStatus, $device ,status = $status ,isOTA = ${mOTAManager!!.isOTA}")
            //ota过程中可能会断连重连
            if (!mOTAManager!!.isOTA) {//非ota状态
                if (status == StateCode.CONNECTION_OK) {
                    //避免升级完成后这里还执行一次
                    if(canOTA(mOtaStatus)) {
                        startOtaProcess()
                    }
                } else if (status == StateCode.CONNECTION_DISCONNECT) {
                    BleLog.d("$TAG ota onConnection -> device disconnected")
                    if(mOtaStatus == OTAStatus.OTA_PREPARE) {
                        updateOtaStatus(OTAStatus.OTA_PREPARE_FAILED, error = "device disconnected")
                    }
                }
            }
        }
    }

    private var mOTAManager: OTAManager? = null

    private var mFilePath: String? = null

    fun startOtaProcess() {
        BleLog.d("$TAG startOtaProcess :: $mFilePath")
        mOTAManager?.bluetoothOption?.firmwareFilePath = mFilePath
        mOTAManager?.startOTA(object : IUpgradeCallback {
            override fun onError(p0: BaseError?) {
                BleLog.d("$TAG onError -> $p0")
                updateOtaStatus(OTAStatus.OTA_FAILED, error = "${p0?.message}")
                destroyOTA()
            }

            override fun onNeedReconnect(p0: String?, p1: Boolean) {
                BleLog.d("$TAG onNeedReconnect : $p0, $p1")
                isUseDfuAddress = true
            }

            override fun onStopOTA() {
                BleLog.d("$TAG onStopOTA upgrade ok")
                updateOtaStatus(OTAStatus.OTA_DONE)
                isUseDfuAddress = false
                destroyOTA()
            }

            override fun onProgress(type: Int, progress: Float) {
                BleLog.d("$TAG onProgress -> $type $progress")
                if (type == 0) {//type 0:校验文件 1:正在升级
                    updateOtaStatus(OTAStatus.OTA_CHECKING, progress = Math.round(progress) / 100.0)
                } else {
                    updateOtaStatus(OTAStatus.OTA_UPGRADEING, progress = Math.round(progress) / 100.0)
                }
            }

            override fun onStartOTA() {
                BleLog.d("$TAG onStartOTA")
                updateOtaStatus(OTAStatus.OTA_START)
            }

            override fun onCancelOTA() {
                BleLog.d("$TAG onCancelOTA")
                updateOtaStatus(OTAStatus.OTA_FAILED)
                destroyOTA()
            }
        })
    }

    init {
        //建议加上log，升级遇到问题可以导出来让原厂分析
        JL_LogUtils.enableLog(mContext)
    }

    override fun startOTA(filePath: String, mac: String?, isDfu: Boolean) {
        BleLog.d("$TAG startOTA -> $filePath, $mac, $isDfu")
        updateOtaStatus(OTAStatus.UNKNOWN)
        //升级失败重置一下ota,不然容易出现重试失败
        destroyOTA()
        initOTA()
        mFilePath = filePath
        mAddress = if (TextUtils.isEmpty(mac))
            BleCache.mBleAddress
        else
            mac
        if(isUseDfuAddress || isDfu) {//如果设备长时间卡在ota界面就用dfu地址
            BleLog.d("$TAG upgrade -> use dfuAddress")
            connectDevice(mAddress?.let { getDfuAddress(it) })
        } else {
            BleLog.d("$TAG upgrade -> use bleAddress")
            connectDevice(mAddress)
        }
        updateOtaStatus(OTAStatus.OTA_PREPARE)
    }

    override fun releaseOTA() {
        destroyOTA()
    }

    private fun canOTA(status: Int): Boolean {
        return !isOTAError(status) && status != OTAStatus.OTA_DONE
    }

    private fun isOTAError(status: Int): Boolean {
        return when(status){
            OTAStatus.OTA_PREPARE_FAILED, OTAStatus.OTA_FAILED -> true
            else -> false
        }
    }

    private fun initOTA() {
        mBluetoothHelper = BluetoothHelper.getInstance(Utils.getApp())
        mBluetoothHelper?.addBluetoothEventListener(mBtEventListener)
        mOTAManager = OTAManager(mContext)
        mOTAManager?.registerBluetoothCallback(mOTAEventCallback)
    }

    private fun destroyOTA(){
        mOTAManager?.unregisterBluetoothCallback(mOTAEventCallback)
        mOTAManager?.release()
        mOTAManager = null
        mBluetoothHelper?.removeBluetoothEventListener(mBtEventListener)
        mBluetoothHelper?.destroy()
        mBluetoothHelper = null
    }

    private fun connectDevice(address: String?) {
        BleLog.d("$TAG connectDevice: $address")
        mBluetoothHelper?.connectDevice(BluetoothAdapter.getDefaultAdapter()?.getRemoteDevice(address))
    }

}