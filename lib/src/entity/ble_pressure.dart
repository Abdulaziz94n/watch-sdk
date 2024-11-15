import 'ble_base.dart';

class BlePressure extends BleBase<BlePressure> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mValue = 0;

  BlePressure();

  @override
  String toString() {
    return "BlePressure(mTime=$mTime, mValue=$mValue)";
  }

  factory BlePressure.fromJson(Map map) {
    BlePressure heartRate = BlePressure();
    heartRate.mTime = map["mTime"];
    heartRate.mValue = map["mValue"];
    return heartRate;
  }

  static List<BlePressure> jsonToList(Map map) {
    List<BlePressure> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BlePressure.fromJson(map));
    }
    return list;
  }
}
