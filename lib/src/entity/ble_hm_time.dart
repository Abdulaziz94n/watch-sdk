import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleHmTime extends BleBase<BleHmTime> {
  int mHour = 0;
  int mMinute = 0;

  BleHmTime(this.mHour, this.mMinute);

  @override
  String toString() {
    return "BleHmTime(mHour=$mHour, mMinute=$mMinute)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mHour"] = mHour;
    map["mMinute"] = mMinute;
    return map;
  }

  factory BleHmTime.fromJson(Map map) {
    BleHmTime hmTime = BleHmTime(0, 0);
    hmTime.mHour = map["mHour"];
    hmTime.mMinute = map["mMinute"];
    return hmTime;
  }
}
