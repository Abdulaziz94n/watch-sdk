import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_time_range.dart';

class BleHrMonitoringSettings extends BleBase<BleHrMonitoringSettings> {
  int mInterval = 60; //分钟，默认60分钟
  BleTimeRange mBleTimeRange = BleTimeRange(0, 0, 0, 0, 0);

  BleHrMonitoringSettings();

  @override
  String toString() {
    return "BleHrMonitoringSettings(mInterval=$mInterval, mBleTimeRange=$mBleTimeRange";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mInterval"] = mInterval;
    map["mBleTimeRange"] = mBleTimeRange.toJson();
    return map;
  }

  factory BleHrMonitoringSettings.fromJson(Map map) {
    BleHrMonitoringSettings hrMonitoringSettings = BleHrMonitoringSettings();
    hrMonitoringSettings.mInterval = map["mInterval"];
    hrMonitoringSettings.mBleTimeRange = BleTimeRange.fromJson(map["mBleTimeRange"]);
    return hrMonitoringSettings;
  }
}
