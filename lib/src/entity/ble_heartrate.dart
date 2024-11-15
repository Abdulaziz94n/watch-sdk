import 'ble_base.dart';

class BleHeartRate extends BleBase<BleHeartRate> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mBpm = 0;

  BleHeartRate();

  @override
  String toString() {
    return "BleHeartRate(mTime=$mTime, mBpm=$mBpm)";
  }

  factory BleHeartRate.fromJson(Map map) {
    BleHeartRate heartRate = BleHeartRate();
    heartRate.mTime = map["mTime"];
    heartRate.mBpm = map["mBpm"];
    return heartRate;
  }

  static List<BleHeartRate> jsonToList(Map map) {
    List<BleHeartRate> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleHeartRate.fromJson(map));
    }
    return list;
  }
}
