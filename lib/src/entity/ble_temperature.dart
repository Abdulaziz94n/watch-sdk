import 'ble_base.dart';

class BleTemperature extends BleBase<BleTemperature> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mTemperature = 0;

  BleTemperature();

  @override
  String toString() {
    return "BleTemperature(mTime=$mTime, mTemperature=$mTemperature)";
  }

  factory BleTemperature.fromJson(Map map) {
    BleTemperature temperature = BleTemperature();
    temperature.mTime = map["mTime"];
    temperature.mTemperature = map["mTemperature"];
    return temperature;
  }

  static List<BleTemperature> jsonToList(Map map) {
    List<BleTemperature> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleTemperature.fromJson(map));
    }
    return list;
  }
}
