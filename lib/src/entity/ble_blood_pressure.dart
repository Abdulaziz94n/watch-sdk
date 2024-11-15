import 'ble_base.dart';

class BleBloodPressure extends BleBase<BleBloodPressure> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mSystolic = 0; // 收缩压
  int mDiastolic = 0; // 舒张压

  BleBloodPressure();

  @override
  String toString() {
    return "BleBloodPressure(mTime=$mTime, mSystolic=$mSystolic, mDiastolic=$mDiastolic)";
  }

  factory BleBloodPressure.fromJson(Map map) {
    BleBloodPressure bloodPressure = BleBloodPressure();
    bloodPressure.mTime = map["mTime"];
    bloodPressure.mSystolic = map["mSystolic"];
    bloodPressure.mDiastolic = map["mDiastolic"];
    return bloodPressure;
  }

  static List<BleBloodPressure> jsonToList(Map map) {
    List<BleBloodPressure> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleBloodPressure.fromJson(map));
    }
    return list;
  }
}
