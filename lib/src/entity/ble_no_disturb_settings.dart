import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_time_range.dart';

class BleNoDisturbSettings extends BleBase<BleNoDisturbSettings> {
  int mEnabled = 0;
  BleTimeRange mBleTimeRange1 = BleTimeRange(0, 0, 0, 0, 0);
  BleTimeRange mBleTimeRange2 = BleTimeRange(0, 0, 0, 0, 0);
  BleTimeRange mBleTimeRange3 = BleTimeRange(0, 0, 0, 0, 0);

  BleNoDisturbSettings();

  @override
  String toString() {
    return "BleTimeRange(mEnabled=$mEnabled, mBleTimeRange1=$mBleTimeRange1, mBleTimeRange2=$mBleTimeRange2, mBleTimeRange3=$mBleTimeRange3)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mEnabled"] = mEnabled;
    map["mBleTimeRange1"] = mBleTimeRange1.toJson();
    map["mBleTimeRange2"] = mBleTimeRange2.toJson();
    map["mBleTimeRange3"] = mBleTimeRange3.toJson();
    return map;
  }

  factory BleNoDisturbSettings.fromJson(Map map) {
    BleNoDisturbSettings noDisturbSettings = BleNoDisturbSettings();
    noDisturbSettings.mEnabled = map["mEnabled"];
    noDisturbSettings.mBleTimeRange1 =
        BleTimeRange.fromJson(map["mBleTimeRange1"]);
    noDisturbSettings.mBleTimeRange2 =
        BleTimeRange.fromJson(map["mBleTimeRange2"]);
    noDisturbSettings.mBleTimeRange3 =
        BleTimeRange.fromJson(map["mBleTimeRange3"]);
    return noDisturbSettings;
  }
}
