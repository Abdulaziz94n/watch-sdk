import 'dart:core';

import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class BleDeviceInfo2 {
  ///设备蓝牙名。
  String? mBleName;

  ///设备蓝牙4.0地址。
  String? mBleAddress;

  ///设备蓝牙3.0地址。
  String? mClassicAddress;

  String mFirmwareVersion = "0.0.0";

  String mUiVersion = "0.0.0";

  String mLanguageVersion = "0.0.0";

  int mLanguageCode = Languages.DEFAULT_CODE;

  String mPlatform = "";

  String mPrototype = "";

  String mFirmwareFlag = "";

  ///完整版本信息
  String mFullVersion = "";

  BleDeviceInfo2();

  @override
  String toString() {
    return "BleDeviceInfo2(mBleName='$mBleName', mBleAddress='$mBleAddress', mClassicAddress='$mClassicAddress', "
        "mFirmwareVersion='$mFirmwareVersion', mUiVersion='$mUiVersion', mLanguageVersion='$mLanguageVersion', "
        "mLanguageCode='$mLanguageCode', mPlatform='$mPlatform', mPrototype='$mPrototype', "
        "mFirmwareFlag='$mFirmwareFlag', mFullVersion='$mFullVersion')";
  }

  factory BleDeviceInfo2.fromJson(Map map) {
    BleDeviceInfo2 deviceInfo = BleDeviceInfo2();
    deviceInfo.mBleName = map["mBleName"];
    deviceInfo.mBleAddress = map["mBleAddress"];
    deviceInfo.mClassicAddress = map["mClassicAddress"];
    deviceInfo.mFirmwareVersion = map["mFirmwareVersion"];
    deviceInfo.mUiVersion = map["mUiVersion"];
    deviceInfo.mLanguageVersion = map["mLanguageVersion"];
    deviceInfo.mLanguageCode = map["mLanguageCode"];
    deviceInfo.mPlatform = map["mPlatform"];
    deviceInfo.mPrototype = map["mPrototype"];
    deviceInfo.mFirmwareFlag = map["mFirmwareFlag"];
    deviceInfo.mFullVersion = map["mFullVersion"];
    return deviceInfo;
  }
}
