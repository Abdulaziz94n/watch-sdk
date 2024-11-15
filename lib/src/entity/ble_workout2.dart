import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleWorkout2 extends BleBase<BleWorkout2> {
  int mStart = 0; //开始时间， 距离当地2000/1/1 00:00:00的秒数
  int mEnd = 0; //结束时间， 距离当地2000/1/1 00:00:00的秒数
  int mDuration = 0; //运动持续时长，数据以秒为单位
  int mAltitude = 0; //海拔高度，数据以米为单位
  int mAirPressure = 0; //气压，数据以 kPa 为单位
  int mSpm = 0; //步频，步数/分钟的值，直接可用
  int mMode = 0; //运动类型，与 BleActivity 中的 mMode 定义一致
  int mStep = 0; //步数，与 BleActivity 中的 mStep 定义一致
  int mDistance = 0; //米，以米为单位，例如接收到的数据为56045，则代表 56045 米 约等于 56.045 Km
  int mCalorie = 0; //卡，以卡为单位，例如接收到的数据为56045，则代表 56.045 Kcal 约等于 56 Kcal
  int mSpeed = 0; //速度，接收到的数据以 米/小时 为单位
  int mPace = 0; //配速，接收到的数据以 秒/千米 为单位
  int mAvgBpm = 0; //平均心率
  int mMaxBpm = 0; //最大心率
  int mMinBpm = 0; //最小心率
  int mMaxSpm = 0; //最大步频，单位：步数每分钟
  int mMinSpm = 0; //最小步频，单位：步数每分钟
  int mMaxPace = 0; //最大(最慢)配速，单位：秒每公里
  int mMinPace = 0; //最小(最快)配速，单位：秒每公里

  BleWorkout2();

  @override
  String toString() {
    return "BleWorkout2(mStart=$mStart, mEnd=$mEnd, mDuration=$mDuration, mAltitude=$mAltitude, "
        "mAirPressure=$mAirPressure, mSpm=$mSpm, mMode=$mMode, mStep=$mStep, mDistance='$mDistance, "
        "mCalorie=$mCalorie, mSpeed=$mSpeed, mPace=$mPace, mAvgBpm=$mAvgBpm, mMaxBpm='$mMaxBpm, "
        "mMaxSpm=$mMaxSpm, mMinBpm=$mMinBpm, mMinSpm=$mMinSpm, mMaxPace=$mMaxPace, mMinPace=$mMinPace)";
  }

  factory BleWorkout2.fromJson(Map map) {
    BleWorkout2 workout = BleWorkout2();
    workout.mStart = map["mStart"];
    workout.mEnd = map["mEnd"];
    workout.mDuration = map["mDuration"];
    workout.mAltitude = map["mAltitude"];
    workout.mAirPressure = map["mAirPressure"];
    workout.mSpm = map["mSpm"];
    workout.mMode = map["mMode"];
    workout.mStep = map["mStep"];
    workout.mDistance = map["mDistance"];
    workout.mCalorie = map["mCalorie"];
    workout.mSpeed = map["mSpeed"];
    workout.mPace = map["mPace"];
    workout.mAvgBpm = map["mAvgBpm"];
    workout.mMaxBpm = map["mMaxBpm"];
    workout.mMinBpm = map["mMinBpm"];
    workout.mMaxSpm = map["mMaxSpm"];
    workout.mMinSpm = map["mMinSpm"];
    workout.mMaxPace = map["mMaxPace"];
    workout.mMinPace = map["mMinPace"];
    return workout;
  }

  static List<BleWorkout2> jsonToList(Map map) {
    List<BleWorkout2> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleWorkout2.fromJson(map));
    }
    return list;
  }
}
