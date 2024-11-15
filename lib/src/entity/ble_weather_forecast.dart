import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_weather.dart';

class BleWeatherForecast extends BleBase<BleWeatherForecast> {
  int mTime = 0; // 时间戳，秒数
  BleWeather mWeather1 = BleWeather();
  BleWeather mWeather2 = BleWeather();
  BleWeather mWeather3 = BleWeather();

  BleWeatherForecast();

  @override
  String toString() {
    return "BleWeatherForecast(mTime=$mTime, mWeather1=$mWeather2, mWeather1=$mWeather2, mWeather3=$mWeather3)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mWeather1"] = mWeather1.toJson();
    map["mWeather2"] = mWeather2.toJson();
    map["mWeather3"] = mWeather3.toJson();
    return map;
  }
}
