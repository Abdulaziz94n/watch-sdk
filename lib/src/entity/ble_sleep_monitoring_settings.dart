import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleSleepMonitoringSettings extends BleBase<BleSleepMonitoringSettings> {
  int mEnabled = 0;
  int mStartHour = 0;
  int mStartMinute = 0;
  int mEndHour = 0;
  int mEndMinute = 0;

  BleSleepMonitoringSettings();

  @override
  String toString() {
    return "BleSleepMonitoringSettings(mEnabled=$mEnabled, mStartHour=$mStartHour, "
        "mStartMinute=$mStartMinute, mEndHour=$mEndHour, mEndMinute=$mEndMinute)";
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

  factory BleSleepMonitoringSettings.fromJson(Map map) {
    BleSleepMonitoringSettings sleepMonitoringSettings = BleSleepMonitoringSettings();
    sleepMonitoringSettings.mEnabled = map["mEnabled"];
    sleepMonitoringSettings.mStartHour = map["mStartHour"];
    sleepMonitoringSettings.mStartMinute = map["mStartMinute"];
    sleepMonitoringSettings.mEndHour = map["mEndHour"];
    sleepMonitoringSettings.mEndMinute = map["mEndMinute"];
    return sleepMonitoringSettings;
  }
}
