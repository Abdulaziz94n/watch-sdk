import 'ble_base.dart';

class BleGirlCareSettings extends BleBase<BleGirlCareSettings> {
  int mEnabled = 0;
  int mReminderHour = 0; // 提醒时间
  int mReminderMinute = 0;
  int mMenstruationReminderAdvance = 0; // 生理期提醒提前天数
  int mOvulationReminderAdvance = 0; // 排卵期提醒提前天数
  int mLatestYear = 0; // 上次生理期日期
  int mLatestMonth = 0;
  int mLatestDay = 0;
  int mMenstruationDuration = 0; // 生理期持续时间，天
  int mMenstruationPeriod = 0; // 生理期周期，天

  BleGirlCareSettings();

  @override
  String toString() {
    return "BleGirlCareSettings(mEnabled=$mEnabled, mReminderHour=$mReminderHour, mReminderMinute=$mReminderMinute"
        ", mMenstruationReminderAdvance=$mMenstruationReminderAdvance, mOvulationReminderAdvance=$mOvulationReminderAdvance"
        ", mLatestYear=$mLatestYear, mLatestMonth=$mLatestMonth, mLatestDay=$mLatestDay, mMenstruationDuration=$mMenstruationDuration, mMenstruationPeriod=$mMenstruationPeriod)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mEnabled"] = mEnabled;
    map["mReminderHour"] = mReminderHour;
    map["mReminderMinute"] = mReminderMinute;
    map["mMenstruationReminderAdvance"] = mMenstruationReminderAdvance;
    map["mOvulationReminderAdvance"] = mOvulationReminderAdvance;
    map["mLatestYear"] = mLatestYear;
    map["mLatestMonth"] = mLatestMonth;
    map["mLatestDay"] = mLatestDay;
    map["mMenstruationDuration"] = mMenstruationDuration;
    map["mMenstruationPeriod"] = mMenstruationPeriod;
    return map;
  }
}
