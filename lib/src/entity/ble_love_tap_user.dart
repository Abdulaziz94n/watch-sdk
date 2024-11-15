import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleLoveTapUser extends BleBase<BleLoveTapUser> {
  int mId = 0; //0-255
  String mName = "";

  BleLoveTapUser();

  @override
  String toString() {
    return "BleLoveTapUser(mId=$mId, mName=$mName)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mId"] = mId;
    map["mName"] = mName;
    return map;
  }

  factory BleLoveTapUser.fromJson(Map map) {
    BleLoveTapUser loveTapUser = BleLoveTapUser();
    loveTapUser.mId = map["mId"];
    loveTapUser.mName = map["mName"];
    return loveTapUser;
  }

  static List<BleLoveTapUser> jsonToList(Map map) {
    List<BleLoveTapUser> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleLoveTapUser.fromJson(map));
    }
    return list;
  }
}
