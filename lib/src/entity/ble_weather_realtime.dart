import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_weather.dart';

class BleWeatherRealtime extends BleBase<BleWeatherRealtime> {
  int mTime = 0; // 时间戳，秒数
  BleWeather mWeather = BleWeather();

  BleWeatherRealtime();

  @override
  String toString() {
    return "BleWeatherRealtime(mWeather=$mWeather)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mWeather"] = mWeather.toJson();
    return map;
  }
}
