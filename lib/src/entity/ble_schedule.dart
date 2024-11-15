import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleSchedule extends BleBase<BleSchedule> {
  int mId = 0;
  int mYear = 0;
  int mMonth = 0;
  int mDay = 0;
  int mHour = 0;
  int mMinute = 0;
  int mAdvance = 0; // 提前提醒分钟数, 0 ~ 0xffff
  String mTitle = "";
  String mContent = "";

  BleSchedule();

  @override
  String toString() {
    return "BleSchedule(mId=$mId, mYear=$mYear, mMonth=$mMonth, mDay=$mDay, "
        "mHour=$mHour, mMinute=$mMinute, mAdvance=$mAdvance, mTitle=$mTitle, mContent=$mContent)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mId"] = mId;
    map["mYear"] = mYear;
    map["mMonth"] = mMonth;
    map["mDay"] = mDay;
    map["mHour"] = mHour;
    map["mMinute"] = mMinute;
    map["mAdvance"] = mAdvance;
    map["mTitle"] = mTitle;
    map["mContent"] = mContent;
    return map;
  }
}
