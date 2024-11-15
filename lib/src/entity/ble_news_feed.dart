import 'ble_base.dart';

class BleNewsFeed extends BleBase<BleNewsFeed> {
  int mCategory = 0;
  int mUid = 0; //unique identifier
  int mTime = 0; // ms
  String mTitle = "";
  String mContent = "";

  BleNewsFeed();

  @override
  String toString() {
    return "BleNewsFeed(mCategory=$mCategory, mUid=$mUid, mTime=$mTime, mTitle=$mTitle, mContent=$mContent)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mCategory"] = mCategory;
    map["mUid"] = mUid;
    map["mTime"] = mTime;
    map["mTitle"] = mTitle;
    map["mContent"] = mContent;
    return map;
  }
}
