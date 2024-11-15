import 'ble_base.dart';

class BleBloodOxygen extends BleBase<BleBloodOxygen> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mValue = 0; // 血氧值，如果传输过来的是50，则最终显示为 50% 即可

  BleBloodOxygen();

  @override
  String toString() {
    return "BleBloodOxygen(mTime=$mTime, mValue=$mValue)";
  }

  factory BleBloodOxygen.fromJson(Map map) {
    BleBloodOxygen bloodOxygen = BleBloodOxygen();
    bloodOxygen.mTime = map["mTime"];
    bloodOxygen.mValue = map["mValue"];
    return bloodOxygen;
  }

  static List<BleBloodOxygen> jsonToList(Map map) {
    List<BleBloodOxygen> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleBloodOxygen.fromJson(map));
    }
    return list;
  }
}
