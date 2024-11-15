import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleDrinkWaterSettings extends BleBase<BleDrinkWaterSettings> {
  int mEnabled = 0;
  int mRepeat = 0;
  int mStartHour = 0;
  int mStartMinute = 0;
  int mEndHour = 0;
  int mEndMinute = 0;
  int mInterval = 0; // 分钟

  BleDrinkWaterSettings();

  @override
  String toString() {
    return "BleDrinkWaterSettings(mEnabled=$mEnabled, mRepeat=$mRepeat, mStartHour=$mStartHour, "
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

  factory BleDrinkWaterSettings.fromJson(Map map) {
    BleDrinkWaterSettings drinkWaterSettings = BleDrinkWaterSettings();
    drinkWaterSettings.mEnabled = map["mEnabled"];
    drinkWaterSettings.mRepeat = map["mRepeat"];
    drinkWaterSettings.mStartHour = map["mStartHour"];
    drinkWaterSettings.mStartMinute = map["mStartMinute"];
    drinkWaterSettings.mEndHour = map["mEndHour"];
    drinkWaterSettings.mEndMinute = map["mEndMinute"];
    drinkWaterSettings.mInterval = map["mInterval"];
    return drinkWaterSettings;
  }
}
