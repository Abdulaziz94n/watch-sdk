import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:sma_coding_dev_flutter_sdk/src/sdk_method.dart';
import 'package:flutter/services.dart';

class BleScanner {
  static const _channelPrefix = 'com.sma.ble';
  static const MethodChannel _channel =
      MethodChannel('$_channelPrefix/ble_scanner', JSONMethodCodec());
  bool isScanning = false;
  BleScanCallback? _callback;

  BleScanner(Duration duration, BleScanCallback callback) {
    _callback = callback;
    _build(duration.inSeconds);
    _addNativeMethodCallHandler();
  }

  void _addNativeMethodCallHandler() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map argMap = call.arguments;
      if (call.method == SdkMethod.onBluetoothDisabled) {
        return _onBluetoothDisabled();
      } else if (call.method == SdkMethod.onScan) {
        return _onScan(argMap);
      } else if (call.method == SdkMethod.onDeviceFound) {
        return _onDeviceFound(argMap);
      }
      return;
    });
  }

  Future<void> _build(int duration) async {
    BleLog.d('_build($duration)');
    Map req = {'duration': duration};
    await _channel.invokeMethod(SdkMethod.build, req);
  }

  Future<void> scan(bool scan) async {
    BleLog.d('scan($scan)');
    Map req = {'scan': scan};
    await _channel.invokeMethod(SdkMethod.scan, req);
  }

  Future<void> exit() async {
    BleLog.d('exit()');
    await _channel.invokeMethod(SdkMethod.exit);
  }

  /// iOS平台才会用到这个方法, 获取当前系统已经配对的设备列表
  /// This method will only be used on the iOS platform
  /// Get the list of devices paired with the current system
  Future<List<BleDevice>> onRetrieveConnectedPeripherals() async {
    BleLog.d('exec onRetrieveConnectedPeripherals()');

    List<BleDevice> list = [];

    var map = await _channel.invokeMethod(SdkMethod.onRetrieveConnectedPeripherals);

    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleDevice.fromJson(map));
    }

    return list;
  }

  Future<void> _onBluetoothDisabled() async {
    BleLog.d("_onBluetoothDisabled");
    _callback?.onBluetoothDisabled();
  }

  Future<void> _onScan(Map map) async {
    BleLog.d("_onScan $map");
    isScanning = map['scan'];
    _callback?.onScan(isScanning);
  }

  Future<void> _onDeviceFound(Map map) async {
    BleLog.d("_onDeviceFound $map");
    _callback?.onDeviceFound(BleDevice.fromJson(map));
  }
}
