package com.sma.sma_coding_dev_flutter_sdk

import com.bestmafen.baseble.scanner.*
import com.bestmafen.baseble.util.BleLog
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject

class BleScannerMethodChannel constructor(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    channelName: String
) : BaseMethodChannel(flutterPluginBinding, channelName), MethodChannel.MethodCallHandler {
    private val TAG = "BleScannerMethodChannel"
    private var mBleScanner: AbsBleScanner? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = if (call.arguments != null) call.arguments as JSONObject else null
        BleLog.d("$TAG -> $param")
        try {
            when (call.method) {
                SdkMethod.build -> {
                    build(param, call.method, result)
                }
                SdkMethod.scan -> {
                    scan(param, call.method, result)
                }
                SdkMethod.exit -> {
                    exit(param, call.method, result)
                }
                else -> {
                    super.onMethodCall(call, result)
                }
            }
        } catch (ignored: JSONException) {
        }
    }

    @Throws(JSONException::class)
    private fun build(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val duration = param?.getInt("duration") ?: 10
        mBleScanner =  ScannerFactory.newInstance()
            .setScanDuration(duration)
            .setBleScanCallback(object : BleScanCallback {

                override fun onBluetoothDisabled() {
                    val data: MutableMap<String, Any> = HashMap()
                    post { channel.invokeMethod(SdkMethod.onBluetoothDisabled, data) }
                }

                override fun onScan(scan: Boolean) {
                    val data: MutableMap<String, Any> = HashMap()
                    data["scan"] = scan
                    post { channel.invokeMethod(SdkMethod.onScan, data) }
                }

                override fun onDeviceFound(device: BleDevice) {
                    val data = BleDeviceHelper.toJson(device)
                    post { channel.invokeMethod(SdkMethod.onDeviceFound, data) }
                }
            })
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun scan(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        val scan = param?.getBoolean("scan") ?: true
        mBleScanner?.scan(scan)
        onResult(result, channelName, true)
    }

    @Throws(JSONException::class)
    private fun exit(param: JSONObject?, channelName: String, result: MethodChannel.Result) {
        mBleScanner?.exit()
        onResult(result, channelName, true)
    }
}