import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_hm_time.dart';

class BleMedicationReminder extends BleBase<BleMedicationReminder> {
  ///[mType]
  static const int TYPE_TABLET = 0; //片剂 tablet
  static const int TYPE_CAPSULE = 1; //胶囊 capsule
  static const int TYPE_DROPS = 2; //滴 drops
  static const int TYPE_CREAM = 3; // Cream
  static const int TYPE_SPRAY = 4; // Spray
  static const int TYPE_SOLUTION = 5; // Solution
  static const int TYPE_INJECTABLE = 6; // Injectable

  /// [mUnit]
  static const int UNIT_MILLIGRAM = 0; //毫克 milligram
  static const int UNIT_MICROGRAM = 1; //微克 microgram
  static const int UNIT_GRAM = 2; //克 gram
  static const int UNIT_MILLILITER = 3; //毫升 milliliter
  static const int UNIT_PERCENTAGE = 4; //百分比 percentage
  static const int UNIT_PIECE = 5; //片 piece
  static const int UNIT_INTERNATIONAL = 6; //国际单位 international
  static const int UNIT_MILLICURIE = 7; //毫居里 millicurie
  static const int UNIT_MILLIEQUIVALENT = 8; //毫当量 milliequivalent

  int mId = 0;
  int mType = 0; //药物类型
  int mUnit = 0; //药物单位，片、粒等
  int mDosage = 0; //药物剂量;根据药物单位来定
  int mRepeat = 0; //重复提醒位Bit 0:6分别代表周一到周日
  int mRemindTimes = 0; //提醒的次数
  BleHmTime mRemindTime1 = BleHmTime(0, 0); //第1次提醒时间
  BleHmTime mRemindTime2 = BleHmTime(0, 0); //第2次提醒时间
  BleHmTime mRemindTime3 = BleHmTime(0, 0); //第3次提醒时间
  BleHmTime mRemindTime4 = BleHmTime(0, 0); //第4次提醒时间
  BleHmTime mRemindTime5 = BleHmTime(0, 0); //第5次提醒时间
  BleHmTime mRemindTime6 = BleHmTime(0, 0); //第6次提醒时间
  int mStartYear = 0; //提醒开始日期
  int mStartMonth = 0;
  int mStartDay = 0;
  int mEndYear = 0; //结束开始日期
  int mEndMonth = 0;
  int mEndDay = 0;
  String mName = ""; //药物名称，UTF-8编码
  String mLabel = ""; //药物说明标签(UTF8编码)

  BleMedicationReminder();

  @override
  String toString() {
    return "BleMedicationReminder(mId=$mId, mType=$mType, mUnit=$mUnit, mDosage=$mDosage, mRepeat=$mRepeat, mRemindTimes=$mRemindTimes, "
        "mRemindTime1=$mRemindTime1, mRemindTime2=$mRemindTime2, mRemindTime3=$mRemindTime3, mRemindTime4=$mRemindTime4, mRemindTime5=$mRemindTime5, mRemindTime6=$mRemindTime6, "
        "mStartYear=$mStartYear, mStartMonth=$mStartMonth, mStartDay=$mStartDay, mEndYear=$mEndYear, mEndMonth=$mEndMonth, mEndDay=$mEndDay, mName='$mName', mLabel='$mLabel')";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mId"] = mId;
    map["mType"] = mType;
    map["mUnit"] = mUnit;
    map["mDosage"] = mDosage;
    map["mRepeat"] = mRepeat;
    map["mRemindTimes"] = mRemindTimes;
    map["mRemindTime1"] = mRemindTime1.toJson();
    map["mRemindTime2"] = mRemindTime2.toJson();
    map["mRemindTime3"] = mRemindTime3.toJson();
    map["mRemindTime4"] = mRemindTime4.toJson();
    map["mRemindTime5"] = mRemindTime5.toJson();
    map["mRemindTime6"] = mRemindTime6.toJson();
    map["mStartYear"] = mStartYear;
    map["mStartMonth"] = mStartMonth;
    map["mStartDay"] = mStartDay;
    map["mEndYear"] = mEndYear;
    map["mEndMonth"] = mEndMonth;
    map["mEndDay"] = mEndDay;
    map["mName"] = mName;
    map["mLabel"] = mLabel;
    return map;
  }

  factory BleMedicationReminder.fromJson(Map map) {
    BleMedicationReminder medicationReminder = BleMedicationReminder();
    medicationReminder.mId = map["mId"];
    medicationReminder.mType = map["mType"];
    medicationReminder.mUnit = map["mUnit"];
    medicationReminder.mDosage = map["mDosage"];
    medicationReminder.mRepeat = map["mRepeat"];
    medicationReminder.mRemindTimes = map["mRemindTimes"];
    medicationReminder.mRemindTime1 = BleHmTime.fromJson(map["mRemindTime1"]);
    medicationReminder.mRemindTime2 = BleHmTime.fromJson(map["mRemindTime2"]);
    medicationReminder.mRemindTime3 = BleHmTime.fromJson(map["mRemindTime3"]);
    medicationReminder.mRemindTime4 = BleHmTime.fromJson(map["mRemindTime4"]);
    medicationReminder.mRemindTime5 = BleHmTime.fromJson(map["mRemindTime5"]);
    medicationReminder.mRemindTime6 = BleHmTime.fromJson(map["mRemindTime6"]);
    medicationReminder.mStartYear = map["mStartYear"];
    medicationReminder.mStartMonth = map["mStartMonth"];
    medicationReminder.mStartDay = map["mStartDay"];
    medicationReminder.mEndYear = map["mEndYear"];
    medicationReminder.mEndMonth = map["mEndMonth"];
    medicationReminder.mEndDay = map["mEndDay"];
    medicationReminder.mName = map["mName"];
    medicationReminder.mLabel = map["mLabel"];
    return medicationReminder;
  }

  static List<BleMedicationReminder> jsonToList(Map map) {
    List<BleMedicationReminder> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleMedicationReminder.fromJson(map));
    }
    return list;
  }
}
