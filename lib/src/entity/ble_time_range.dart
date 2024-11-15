import 'ble_base.dart';

class BleTimeRange extends BleBase<BleTimeRange> {
  int mEnabled = 0;
  int mStartHour = 0;
  int mStartMinute = 0;
  int mEndHour = 0;
  int mEndMinute = 0;

  BleTimeRange(this.mEnabled, this.mStartHour, this.mStartMinute, this.mEndHour,
      this.mEndMinute);

  @override
  String toString() {
    return "BleTimeRange(mEnabled=$mEnabled, mStartHour=$mStartHour, mStartMinute=$mStartMinute, mEndHour=$mEndHour, mEndMinute=$mEndMinute)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mEnabled"] = mEnabled;
    map["mStartHour"] = mStartHour;
    map["mStartMinute"] = mStartMinute;
    map["mEndHour"] = mEndHour;
    map["mEndMinute"] = mEndMinute;
    return map;
  }

  factory BleTimeRange.fromJson(Map map) {
    BleTimeRange timeRange = BleTimeRange(0, 0, 0, 0, 0);
    timeRange.mEnabled = map["mEnabled"];
    timeRange.mStartHour = map["mStartHour"];
    timeRange.mStartMinute = map["mStartMinute"];
    timeRange.mEndHour = map["mEndHour"];
    timeRange.mEndMinute = map["mEndMinute"];
    return timeRange;
  }
}
