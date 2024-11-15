import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

class BleUserProfile extends BleBase<BleUserProfile> {
  static const int METRIC = 0;
  static const int IMPERIAL = 1;

  static const int FEMALE = 0;
  static const int MALE = 1;

  int mUnit = METRIC;
  int mGender = FEMALE;
  int mAge = 20;
  double mHeight = 170;
  double mWeight = 60;

  BleUserProfile();

  @override
  String toString() {
    return "BleUserProfile(mUnit=$mUnit, mGender=$mGender, mAge=$mAge, mHeight=$mHeight, mWeight=$mWeight)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mUnit"] = mUnit;
    map["mGender"] = mGender;
    map["mAge"] = mAge;
    map["mHeight"] = mHeight;
    map["mWeight"] = mWeight;
    return map;
  }

  factory BleUserProfile.fromJson(Map map) {
    BleUserProfile userProfile = BleUserProfile();
    userProfile.mUnit = map["mUnit"];
    userProfile.mGender = map["mGender"];
    userProfile.mAge = map["mAge"];
    userProfile.mHeight = map["mHeight"];
    userProfile.mWeight = map["mWeight"];
    return userProfile;
  }
}
