import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'ble_weather2.dart';

class BleWeatherForecast2 extends BleBase<BleWeatherForecast2> {
  int mTime = 0; // 时间戳，秒数
  String? mCityName; //城市名
  BleWeather2 mWeather1 = BleWeather2();
  BleWeather2 mWeather2 = BleWeather2();
  BleWeather2 mWeather3 = BleWeather2();
  BleWeather2 mWeather4 = BleWeather2();
  BleWeather2 mWeather5 = BleWeather2();
  BleWeather2 mWeather6 = BleWeather2();
  BleWeather2 mWeather7 = BleWeather2();

  BleWeatherForecast2();

  @override
  String toString() {
    return "BleWeatherForecast2(mTime=$mTime, mCityName=$mCityName, mWeather1=$mWeather2, mWeather1=$mWeather2, mWeather3=$mWeather3, "
        "mWeather4=$mWeather4, mWeather5=$mWeather5, mWeather6=$mWeather6, mWeather7=$mWeather7)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mCityName"] = mCityName;
    map["mWeather1"] = mWeather1.toJson();
    map["mWeather2"] = mWeather2.toJson();
    map["mWeather3"] = mWeather3.toJson();
    map["mWeather4"] = mWeather4.toJson();
    map["mWeather5"] = mWeather5.toJson();
    map["mWeather6"] = mWeather6.toJson();
    map["mWeather7"] = mWeather7.toJson();
    return map;
  }
}
