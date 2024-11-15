package com.sma.sma_coding_dev_flutter_sdk

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

open class BaseMethodChannel : MethodChannel.MethodCallHandler {

    var context: Context
    var binging: FlutterPlugin.FlutterPluginBinding
    var channel: MethodChannel

    constructor(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, channelName: String) {
        context = flutterPluginBinding.applicationContext
        binging = flutterPluginBinding
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            CHANNEL_PREFIX + channelName,
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)
    }

    open fun post(runnable: Runnable) {
        SmaCodingDevFlutterSdkPlugin.handler.post(runnable)
    }

    open fun onResult(result: MethodChannel.Result, name: String, obj: Any?) {
        post {
            val data: MutableMap<String, Any> =
                HashMap()
            if (obj != null) {
                data[name] = obj
            }
            result.success(data)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }

    companion object {
        private const val CHANNEL_PREFIX = "com.sma.ble/"
    }
}