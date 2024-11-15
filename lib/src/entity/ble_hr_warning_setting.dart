import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleHrWarningSettings extends BleBase<BleHrWarningSettings> {
  int mHighSwitch = 0; //心率过高提醒开关
  int mHighValue = 0; //过高心率提醒阈值
  int mLowSwitch = 0; //心率过低提醒开关
  int mLowValue = 0; //过低心率提醒阈值

  BleHrWarningSettings();

  @override
  String toString() {
    return "BleHrWarningSettings(mHighSwitch=$mHighSwitch, mHighValue=$mHighValue, mLowSwitch=$mLowSwitch, mLowValue=$mLowValue)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mHighSwitch"] = mHighSwitch;
    map["mHighValue"] = mHighValue;
    map["mLowSwitch"] = mLowSwitch;
    map["mLowValue"] = mLowValue;
    return map;
  }

  factory BleHrWarningSettings.fromJson(Map map) {
    BleHrWarningSettings hrWarningSettings = BleHrWarningSettings();
    hrWarningSettings.mHighSwitch = map["mHighSwitch"];
    hrWarningSettings.mHighValue = map["mHighValue"];
    hrWarningSettings.mLowSwitch = map["mLowSwitch"];
    hrWarningSettings.mLowValue = map["mLowValue"];
    return hrWarningSettings;
  }
}
