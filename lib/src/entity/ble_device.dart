import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleDevice extends BleBase<BleDevice> {
  String mName = "";

  String mAddress = "";

  /// Only iOS can use this, this is the UUID of the returned device
  String identifier = "";

  int mRssi = 0;

  /// 是否处在ota模式，固件修复搜索时用到
  bool isDfu = false;

  BleDevice();

  @override
  bool operator ==(Object other) {
    if (other is BleDevice) {
      return mAddress == other.mAddress;
    }
    return false;
  }

  factory BleDevice.fromJson(Map map) {
    BleDevice device = BleDevice();
    device.mName = map["mName"];
    device.mAddress = map["mAddress"];
    device.mRssi = map["mRssi"];
    device.isDfu = map["isDfu"];

    // Only iOS can use this
    if (map.containsKey("identifier")) {
      device.identifier = map["identifier"];
    }

    return device;
  }
}
