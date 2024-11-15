import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleSedentarinessSettings extends BleBase<BleSedentarinessSettings> {
  int mEnabled = 0;
  int mRepeat = 0;
  int mStartHour = 0;
  int mStartMinute = 0;
  int mEndHour = 0;
  int mEndMinute = 0;
  int mInterval = 0; // 分钟数

  BleSedentarinessSettings();

  @override
  String toString() {
    return "BleSedentarinessSettings(mEnabled=$mEnabled, mRepeat=$mRepeat, mStartHour=$mStartHour, "
        "mStartMinute=$mStartMinute, mEndHour=$mEndHour, mEndMinute=$mEndMinute, mInterval=$mInterval)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mEnabled"] = mEnabled;
    map["mRepeat"] = mRepeat;
    map["mStartHour"] = mStartHour;
    map["mStartMinute"] = mStartMinute;
    map["mEndHour"] = mEndHour;
    map["mEndMinute"] = mEndMinute;
    map["mInterval"] = mInterval;
    return map;
  }

  factory BleSedentarinessSettings.fromJson(Map map) {
    BleSedentarinessSettings sedentarinessSettings = BleSedentarinessSettings();
    sedentarinessSettings.mEnabled = map["mEnabled"];
    sedentarinessSettings.mRepeat = map["mRepeat"];
    sedentarinessSettings.mStartHour = map["mStartHour"];
    sedentarinessSettings.mStartMinute = map["mStartMinute"];
    sedentarinessSettings.mEndHour = map["mEndHour"];
    sedentarinessSettings.mEndMinute = map["mEndMinute"];
    sedentarinessSettings.mInterval = map["mInterval"];
    return sedentarinessSettings;
  }
}
