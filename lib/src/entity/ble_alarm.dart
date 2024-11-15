import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleAlarm extends BleBase<BleAlarm> {
  int mId = 0;
  int mEnabled = 1;
  int mRepeat = 0;
  int mYear = 0;
  int mMonth = 0;
  int mDay = 0;
  int mHour = 0;
  int mMinute = 0;
  String mTag = "";

  BleAlarm();

  @override
  String toString() {
    return "BleAlarm(mId=$mId, mEnabled=$mEnabled, mRepeat=$mRepeat, mYear=$mYear, mMonth=$mMonth, mDay=$mDay, mHour=$mHour, mMinute=$mMinute, mTag='$mTag')";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mId"] = mId;
    map["mEnabled"] = mEnabled;
    map["mRepeat"] = mRepeat;
    map["mYear"] = mYear;
    map["mMonth"] = mMonth;
    map["mDay"] = mDay;
    map["mHour"] = mHour;
    map["mMinute"] = mMinute;
    map["mTag"] = mTag;
    return map;
  }

  factory BleAlarm.fromJson(Map map) {
    BleAlarm alarm = BleAlarm();
    alarm.mId = map["mId"];
    alarm.mEnabled = map["mEnabled"];
    alarm.mRepeat = map["mRepeat"];
    alarm.mYear = map["mYear"];
    alarm.mMonth = map["mMonth"];
    alarm.mDay = map["mDay"];
    alarm.mHour = map["mHour"];
    alarm.mMinute = map["mMinute"];
    alarm.mTag = map["mTag"];
    return alarm;
  }

  static List<BleAlarm> jsonToList(Map map) {
    List<BleAlarm> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleAlarm.fromJson(map));
    }
    return list;
  }
}
