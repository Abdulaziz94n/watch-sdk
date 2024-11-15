import 'ble_base.dart';
import 'languages.dart';

class BleLanguagePackVersion extends BleBase<BleLanguagePackVersion> {
  String mVersion = "0.0.0";
  int mLanguageCode = Languages.DEFAULT_CODE;

  BleLanguagePackVersion();

  @override
  String toString() {
    return "BleLanguagePackVersion(mVersion=$mVersion, mLanguageCode=$mLanguageCode)";
  }

  factory BleLanguagePackVersion.fromJson(Map map) {
    BleLanguagePackVersion version = BleLanguagePackVersion();
    version.mVersion = map["mVersion"];
    version.mLanguageCode = map["mLanguageCode"];
    return version;
  }
}
