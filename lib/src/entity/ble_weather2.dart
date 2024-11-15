import 'ble_base.dart';

class BleWeather2 extends BleBase<BleWeather2> {
  ///[mWeatherCode]
  static const SUNNY = 1; //晴
  static const CLOUDY = 2; //多云
  static const OVERCAST = 3; //阴天
  static const RAINY = 4; //雨天
  static const THUNDER = 5; //打雷
  static const THUNDERSHOWER = 6; //雷阵雨
  static const HIGH_WINDY = 7; //大风
  static const SNOWY = 8; //下雪
  static const FOGGY = 9; //雾气
  static const SAND_STORM = 10; //沙尘暴
  static const HAZE = 11; //阴霾
  static const WIND = 12; //风
  static const DRIZZLE = 13; //细雨
  static const HEAVY_RAIN = 14; //大雨
  static const LIGHTNING = 15; //闪电
  static const LIGHT_SNOW = 16; //小雪
  static const HEAVY_SNOW = 17; //暴雪
  static const SLEET = 18; //雨夹雪
  static const TORNADO = 19; //龙卷风
  static const SNOWSTORM = 20; //暴风雪
  static const OTHER = 0; //没有天气

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
  int mSunriseHour = 0; // 日出小时
  int mSunrisMinute = 0; // 日出分钟
  int mSunrisSecond = 0; // 日出秒
  int mSunsetHour = 0; // 日落小时
  int mSunsetMinute = 0; // 日落分钟
  int mSunsetSecond = 0; // 日落秒

  BleWeather2();

  @override
  String toString() {
    return "BleWeather2(mCurrentTemperature=$mCurrentTemperature, mMaxTemperature=$mMaxTemperature, mMinTemperature=$mMinTemperature"
        ", mWeatherCode=$mWeatherCode, mWindSpeed=$mWindSpeed, mHumidity=$mHumidity, mVisibility=$mVisibility"
        ", mUltraVioletIntensity=$mUltraVioletIntensity, mPrecipitation=$mPrecipitation, mSunriseHour=$mSunriseHour"
        ", mSunrisMinute=$mSunrisMinute, mSunrisSecond=$mSunrisSecond, mSunsetHour=$mSunsetHour, mSunsetMinute=$mSunsetMinute, mSunsetSecond=$mSunsetSecond)";
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
    map["mSunriseHour"] = mSunriseHour;
    map["mSunrisMinute"] = mSunrisMinute;
    map["mSunrisSecond"] = mSunrisSecond;
    map["mSunsetHour"] = mSunsetHour;
    map["mSunsetMinute"] = mSunsetMinute;
    map["mSunsetSecond"] = mSunsetSecond;
    return map;
  }
}
