package com.sma.sma_coding_dev_flutter_sdk

import android.content.Context
import com.bestmafen.baseble.util.BleLog

abstract class BaseOTAManager(context: Context, callback: OTACallback) {

    interface OTACallback {
        /**
         * @param otaStatus [OTAStatus]
         * @param error 主要是平台sdk返回的错误信息
         */
        fun onOTAProgress(progress: Double, otaStatus: Int, error: String)
    }

    protected var mContext: Context = context

    private var mCallback: OTACallback = callback

    var mOtaStatus = OTAStatus.UNKNOWN

    var mAddress: String? = null

    open fun startOTA(filePath: String, address: String? = null, isDfu: Boolean = false) {}

    open fun releaseOTA() {}

    fun updateOtaStatus(otaStatus: Int, error: String = "", progress: Double = 0.0) {
        mOtaStatus = otaStatus
        if (otaStatus != OTAStatus.OTA_CHECKING && otaStatus != OTAStatus.OTA_UPGRADEING) {
            BleLog.d("updateOtaStatus -> otaStatus:$otaStatus")
        }
        mCallback.onOTAProgress(progress, otaStatus, error)
    }

    /**
     * address + 1
     */
    fun getDfuAddress(address: String): String {
        var addressHex = address.replace(":", "")
        val addressLong = addressHex.toLong(16) + 1
        addressHex = String.format("%012X", addressLong)
        return addressHex.chunked(2).joinToString(":")
    }
}