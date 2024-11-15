package com.sma.sma_coding_dev_flutter_sdk

import android.content.Context
import android.text.TextUtils
import com.bestmafen.baseble.util.BleLog
import com.blankj.utilcode.util.LogUtils
import com.realsil.sdk.dfu.DfuConstants
import com.realsil.sdk.dfu.model.DfuConfig
import com.realsil.sdk.dfu.model.DfuProgressInfo
import com.realsil.sdk.dfu.model.OtaDeviceInfo
import com.realsil.sdk.dfu.model.Throughput
import com.realsil.sdk.dfu.utils.ConnectParams
import com.realsil.sdk.dfu.utils.DfuAdapter
import com.realsil.sdk.dfu.utils.GattDfuAdapter
import com.szabh.smable3.component.BleCache

class ROTAManager(context: Context, callback: OTACallback) : BaseOTAManager(context, callback) {

    private val TAG = "ROTAManager"

    private val mDfuHelper by lazy { GattDfuAdapter.getInstance(mContext) }
    private val mDfuCallback = object : DfuAdapter.DfuHelperCallback() {

        override fun onStateChanged(state: Int) {
            BleLog.d("$TAG onStateChanged -> state = $state")
            when (state) {
                DfuAdapter.STATE_INIT_OK -> {
                    mAddress?.let { otaConnect(it) }
                }
                DfuAdapter.STATE_DISCONNECTED -> {
                    updateOtaStatus(OTAStatus.OTA_FAILED, error = "STATE_DISCONNECTED")
                }
//               DfuAdapter.STATE_INIT_OK -> tvStep.text = "STATE_INIT_OK"
                DfuAdapter.STATE_PREPARED -> {
                    updateOtaStatus(OTAStatus.OTA_START, error = "STATE_DISCONNECTED")
                    mOtaDeviceInfo = mDfuHelper.otaDeviceInfo
                    BleLog.d("$TAG onStateChanged -> mOtaDeviceInfo = $mOtaDeviceInfo")
                    startOtaProcess()
                }
//                    DfuAdapter.STATE_CONNECTING -> tvStep.text = "STATE_CONNECTING"
//                    DfuAdapter.STATE_OTA_PROCESSING -> tvStep.text = "STATE_OTA_PROCESSING"
//                    DfuAdapter.STATE_DISCONNECTED -> tvStep.text = "STATE_DISCONNECTED"
//                    DfuAdapter.STATE_CONNECT_FAILED -> tvStep.text = "STATE_CONNECT_FAILED"
//                    DfuAdapter.STATE_ABORTED -> tvStep.text = "STATE_ABORTED"
                else -> {
                }
            }

        }

        override fun onError(type: Int, code: Int) {
            updateOtaStatus(OTAStatus.OTA_FAILED, error = "type=$type, code=$code")
        }

        override fun onProcessStateChanged(state: Int, throughput: Throughput?) {
            if (state == DfuConstants.PROGRESS_IMAGE_ACTIVE_SUCCESS) {
                updateOtaStatus(OTAStatus.OTA_DONE)
            }
        }

        override fun onProgressChanged(progressInfo: DfuProgressInfo) {
            updateOtaStatus(OTAStatus.OTA_UPGRADEING, progress = progressInfo.progress / 100.0)
        }
    }

    private var mDfuConfig: DfuConfig? = null

    private var mOtaDeviceInfo: OtaDeviceInfo? = null

    private var mFilePath: String? = null

    override fun startOTA(filePath: String, mac: String?, isDfu: Boolean) {
        BleLog.d("$TAG startOTA -> $filePath, $mac")
        mFilePath = filePath
        mAddress = if (TextUtils.isEmpty(mac))
            BleCache.mBleAddress
        else
            mac
        mDfuConfig = DfuConfig().apply {
            address = mAddress
            isAutomaticActiveEnabled = true
            fileLocation = DfuConfig.FILE_LOCATION_SDCARD
            isVersionCheckEnabled = false
        }
        updateOtaStatus(OTAStatus.OTA_PREPARE)
        mDfuHelper.initialize(mDfuCallback)
    }

    private fun otaConnect(address: String) {
        BleLog.d("$TAG ota connect $address")
        val connectParamsBuilder = ConnectParams.Builder()
            .address(address)
            .reconnectTimes(3)
        mDfuHelper.connectDevice(connectParamsBuilder.build())
    }

    private fun startOtaProcess() {
        BleLog.d("$TAG start ota process")
        mDfuConfig?.also {
            it.otaWorkMode = DfuConstants.OTA_MODE_NORMAL_FUNCTION
            it.filePath = mFilePath
            mDfuHelper?.startOtaProcedure(it, mOtaDeviceInfo, true)
        }
    }

    override fun releaseOTA() {
        BleLog.d("$TAG release ota")
        mDfuHelper?.run {
            abort()
            close()
        }
    }
}