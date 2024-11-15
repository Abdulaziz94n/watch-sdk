import 'ble_base.dart';

class BleLocation extends BleBase<BleLocation> {
  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mActivityMode = 0;
  int mAltitude = 0; // m
  double mLongitude = 0;
  double mLatitude = 0;

  BleLocation();

  @override
  String toString() {
    return "BleLocation(mTime=$mTime, mActivityMode=$mActivityMode, mAltitude=$mAltitude, mLongitude=$mLongitude, mLatitude=$mLatitude)";
  }

  factory BleLocation.fromJson(Map map) {
    BleLocation location = BleLocation();
    location.mTime = map["mTime"];
    location.mActivityMode = map["mActivityMode"];
    location.mAltitude = map["mAltitude"];
    location.mLongitude = map["mLongitude"];
    location.mLatitude = map["mLatitude"];
    return location;
  }

  static List<BleLocation> jsonToList(Map map) {
    List<BleLocation> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleLocation.fromJson(map));
    }
    return list;
  }
}
