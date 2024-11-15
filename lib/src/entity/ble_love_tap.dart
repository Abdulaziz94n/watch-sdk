import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_time_range.dart';

class BleLoveTap extends BleBase<BleLoveTap> {
  static const int ACTION_DOWN = 1;
  static const int ACTION_UP = 2;

  int mTime = 0;
  int mId = 0;
  int mActionType = 0;

  BleLoveTap();

  @override
  String toString() {
    return "BleLoveTap(mTime=$mTime, mId=$mId, mActionType=$mActionType)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mId"] = mId;
    map["mActionType"] = mActionType;
    return map;
  }

  factory BleLoveTap.fromJson(Map map) {
    BleLoveTap loveTap = BleLoveTap();
    loveTap.mTime = map["mTime"];
    loveTap.mId = map["mId"];
    loveTap.mActionType = map["mActionType"];
    return loveTap;
  }
}
