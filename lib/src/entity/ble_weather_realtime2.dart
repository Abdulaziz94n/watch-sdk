import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_weather2.dart';

class BleWeatherRealtime2 extends BleBase<BleWeatherRealtime2> {
  int mTime = 0; // 时间戳，秒数
  String? mCityName; //城市名
  BleWeather2 mWeather = BleWeather2();

  BleWeatherRealtime2();

  @override
  String toString() {
    return "BleWeatherRealtime2(mTime=$mTime, mCityName=$mCityName, mWeather=$mWeather)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mCityName"] = mCityName;
    map["mWeather"] = mWeather.toJson();
    return map;
  }
}
