import 'ble_base.dart';

class BleWeather extends BleBase<BleWeather> {
  // weather types
  static const int SUNNY = 1;
  static const int CLOUDY = 2;
  static const int OVERCAST = 3;
  static const int RAINY = 4;
  static const int THUNDER = 5;
  static const int THUNDERSHOWER = 6;
  static const int HIGH_WINDY = 7;
  static const int SNOWY = 8;
  static const int FOGGY = 9;
  static const int SAND_STORM = 10;
  static const int HAZE = 11;
  static const int OTHER = 0;

  int mCurrentTemperature = 0; // 摄氏度，for BleWeatherRealtime
  int mMaxTemperature = 0; // 摄氏度，for BleWeatherForecast
  int mMinTemperature = 0; // 摄氏度，for BleWeatherForecast
  int mWeatherCode = 0; // 天气类型，for both
  int mWindSpeed = 0; // km/h，for both
  int mHumidity = 0; // %，for both
  int mVisibility = 0; // km，for both
  // https://en.wikipedia.org/wiki/Ultraviolet_index
  // https://zh.wikipedia.org/wiki/%E7%B4%AB%E5%A4%96%E7%BA%BF%E6%8C%87%E6%95%B0
  // [0, 2] -> low, [3, 5] -> moderate, [6, 7] -> high, [8, 10] -> very high, >10 -> extreme
  int mUltraVioletIntensity = 0; // 紫外线强度，for BleWeatherForecast
  int mPrecipitation = 0; // 降水量 mm，for both

  BleWeather();

  @override
  String toString() {
    return "BleWeather(mCurrentTemperature=$mCurrentTemperature, mMaxTemperature=$mMaxTemperature, mMinTemperature=$mMinTemperature"
        ", mWeatherCode=$mWeatherCode, mWindSpeed=$mWindSpeed, mHumidity=$mHumidity, mVisibility=$mVisibility"
        ", mUltraVioletIntensity=$mUltraVioletIntensity, mPrecipitation=$mPrecipitation)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mCurrentTemperature"] = mCurrentTemperature;
    map["mMaxTemperature"] = mMaxTemperature;
    map["mMinTemperature"] = mMinTemperature;
    map["mWeatherCode"] = mWeatherCode;
    map["mWindSpeed"] = mWindSpeed;
    map["mHumidity"] = mHumidity;
    map["mVisibility"] = mVisibility;
    map["mUltraVioletIntensity"] = mUltraVioletIntensity;
    map["mPrecipitation"] = mPrecipitation;
    return map;
  }
}
