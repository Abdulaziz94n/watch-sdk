package com.sma.sma_coding_dev_flutter_sdk

import android.os.Handler
import android.os.Looper
import com.bestmafen.baseble.util.BleLog
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class SmaCodingDevFlutterSdkPlugin : FlutterPlugin {

    private val TAG = "SmaCodingDevFlutterSdkPlugin"

    private var mMethodChannel: MethodChannel? = null
    private var mMethodCallHandler: BleConnectorMethodChannel? = null

    companion object {
        val handler = Handler(Looper.getMainLooper())
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        BleLog.d("$TAG -> onAttachedToEngine")
        mMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "ble_connector")
        mMethodCallHandler = BleConnectorMethodChannel(flutterPluginBinding, "ble_connector")
        mMethodChannel?.setMethodCallHandler(mMethodCallHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        BleLog.d("$TAG -> onDetachedFromEngine")
        mMethodChannel?.setMethodCallHandler(null)
        mMethodChannel = null
        mMethodCallHandler = null
    }
}
