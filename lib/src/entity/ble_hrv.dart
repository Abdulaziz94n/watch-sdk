import 'ble_base.dart';

class BleHrv extends BleBase<BleHrv> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mValue = 0; // 最近一次测量的值，如果传输过来的是50，则最终显示为 50 即可
  int mAvgValue = 0; // 当天固件计算得出的HRV平均值，如果传输过来的是50，则最终显示为 50

  BleHrv();

  @override
  String toString() {
    return "BleHrv(mTime=$mTime, mValue=$mValue, mAvgValue=$mAvgValue)";
  }

  factory BleHrv.fromJson(Map map) {
    BleHrv heartRate = BleHrv();
    heartRate.mTime = map["mTime"];
    heartRate.mValue = map["mValue"];
    heartRate.mAvgValue = map["mAvgValue"];
    return heartRate;
  }

  static List<BleHrv> jsonToList(Map map) {
    List<BleHrv> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleHrv.fromJson(map));
    }
    return list;
  }
}
