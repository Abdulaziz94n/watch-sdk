//
//  BleWeather2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

public enum BleWeather2Type: Int {
    /// 没有天气
    case OTHER = 0
    /// 晴
    case SUNNY = 1
    /// 多云
    case CLOUDY
    /// 阴天
    case OVERCAST
    /// 雨天
    case RAINY
    /// 打雷
    case THUNDER
    /// 雷阵雨
    case THUNDERSHOWER
    /// 大风
    case HIGH_WINDY
    /// 下雪
    case SNOWY
    /// 雾气
    case FOGGY
    /// 沙尘暴
    case SAND_STORM
    /// 阴霾
    case HAZE
    /// 凤
    case WIND
    /// 细雨
    case DRIZZLE
    /// 大雨
    case HEAVY_RAIN
    /// 闪电
    case LIGHTNING
    /// 小雪
    case LIGHT_SNOW
    /// 暴雪
    case HEAVY_SNOW
    /// 雨夹雪，冻雨；雨淞
    case SLEET
    /// 龙卷风
    case TORNADO
    /// 暴风雪
    case SNOWSTORM
}

open class BleWeather2: BleWritable {

    /// 天气温度取值最大值127最小值-127
    /// The maximum value of weather temperature is 127 and the minimum value is -127
    public var mCurrentTemperature: Int = 0 // 摄氏度，for BleWeatherRealtime
    public var mMaxTemperature: Int = 0     // 摄氏度，for BleWeatherForecast
    public var mMinTemperature: Int = 0     // 摄氏度，for BleWeatherForecast
    public var mWeatherCode: Int = 0        // 天气类型，for both
    public var mWindSpeed: Int = 0          // km/h，for both
    public var mHumidity: Int = 0           // %，for both
    public var mVisibility: Int = 0         // km，for both
    // https://en.wikipedia.org/wiki/Ultraviolet_index
    // https://zh.wikipedia.org/wiki/%E7%B4%AB%E5%A4%96%E7%BA%BF%E6%8C%87%E6%95%B0
    // [0, 2] -> low, [3, 5] -> moderate, [6, 7] -> high, [8, 10] -> very high, >10 -> extreme
    public var mUltraVioletIntensity: Int = 0 // 紫外线强度，for BleWeatherForecast
    public var mPrecipitation: Int = 0        // 降水量 mm，for both
    public var mSunriseHour: Int = 0          // 日出小时
    public var mSunrisMinute: Int = 0         // 日出分钟
    public var mSunrisSecond: Int = 0         // 日出秒
    public var mSunsetHour: Int = 0           // 日落小时
    public var mSunsetMinute: Int = 0         // 日落分钟
    public var mSunsetSecond: Int = 0         // 日落秒
    @available(*, deprecated, message: "Altitude has expired and is no longer used. Please use mAQI attribute")
    public var mAltitude: Int = 0             // 海拔, 单位米
    /// 空气质量指数AQI
    public var mAQI: Int = 0
    
    static let ITEM_LENGTH = 20
    override var mLengthToWrite: Int {
        return BleWeather2.ITEM_LENGTH
    }
    
    public init(mCurrentTemperature: Int, mMaxTemperature: Int, mMinTemperature: Int, mWeatherCode: Int, mWindSpeed: Int, mHumidity: Int, mVisibility: Int, mUltraVioletIntensity: Int, mPrecipitation: Int, mSunriseHour: Int, mSunrisMinute: Int, mSunrisSecond: Int, mSunsetHour: Int, mSunsetMinute: Int, mSunsetSecond: Int, mAQI: Int) {
        super.init()
        
        self.mCurrentTemperature = mCurrentTemperature
        self.mMaxTemperature = mMaxTemperature
        self.mMinTemperature = mMinTemperature
        self.mWeatherCode = mWeatherCode
        self.mWindSpeed = mWindSpeed
        self.mHumidity = mHumidity
        self.mVisibility = mVisibility
        self.mUltraVioletIntensity = mUltraVioletIntensity
        self.mPrecipitation = mPrecipitation
        // 下面是新增的
        self.mSunriseHour = mSunriseHour
        self.mSunrisMinute = mSunrisMinute
        self.mSunrisSecond = mSunrisSecond
        self.mSunsetHour = mSunsetHour
        self.mSunsetMinute = mSunsetMinute
        self.mSunsetSecond = mSunsetSecond
        //self.mAltitude = mAltitude
        self.mAQI = mAQI
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mCurrentTemperature = try container.decode(Int.self, forKey: .mCurrentTemperature)
        mMaxTemperature = try container.decode(Int.self, forKey: .mMaxTemperature)
        mMinTemperature = try container.decode(Int.self, forKey: .mMinTemperature)
        mWeatherCode = try container.decode(Int.self, forKey: .mWeatherCode)
        mWindSpeed = try container.decode(Int.self, forKey: .mWindSpeed)
        mHumidity = try container.decode(Int.self, forKey: .mHumidity)
        mVisibility = try container.decode(Int.self, forKey: .mVisibility)
        mUltraVioletIntensity = try container.decode(Int.self, forKey: .mUltraVioletIntensity)
        mPrecipitation = try container.decode(Int.self, forKey: .mPrecipitation)
        // 下面是新增的
        mSunriseHour = try container.decode(Int.self, forKey: .mSunriseHour)
        mSunrisMinute = try container.decode(Int.self, forKey: .mSunrisMinute)
        mSunrisSecond = try container.decode(Int.self, forKey: .mSunrisSecond)
        mSunsetHour = try container.decode(Int.self, forKey: .mSunsetHour)
        mSunsetMinute = try container.decode(Int.self, forKey: .mSunsetMinute)
        mSunsetSecond = try container.decode(Int.self, forKey: .mSunsetSecond)
        mAltitude = try container.decode(Int.self, forKey: .mAltitude)
        mAQI = try container.decode(Int.self, forKey: .mAQI)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mCurrentTemperature, forKey: .mCurrentTemperature)
        try container.encode(mMaxTemperature, forKey: .mMaxTemperature)
        try container.encode(mMinTemperature, forKey: .mMinTemperature)
        try container.encode(mWeatherCode, forKey: .mWeatherCode)
        try container.encode(mWindSpeed, forKey: .mWindSpeed)
        try container.encode(mHumidity, forKey: .mHumidity)
        try container.encode(mVisibility, forKey: .mVisibility)
        try container.encode(mUltraVioletIntensity, forKey: .mUltraVioletIntensity)
        try container.encode(mPrecipitation, forKey: .mPrecipitation)
        // 下面是新增的
        try container.encode(mSunriseHour, forKey: .mSunriseHour)
        try container.encode(mSunrisMinute, forKey: .mSunrisMinute)
        try container.encode(mSunrisSecond, forKey: .mSunrisSecond)
        try container.encode(mSunsetHour, forKey: .mSunsetHour)
        try container.encode(mSunsetMinute, forKey: .mSunsetMinute)
        try container.encode(mSunsetSecond, forKey: .mSunsetSecond)
        try container.encode(mAltitude, forKey: .mAltitude)
        try container.encode(mAQI, forKey: .mAQI)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mCurrentTemperature, mMaxTemperature, mMinTemperature, mWeatherCode, mWindSpeed, mHumidity,
             mVisibility, mUltraVioletIntensity, mPrecipitation,
        // 下面是新增的
        mSunriseHour, mSunrisMinute, mSunrisSecond, mSunsetHour, mSunsetMinute, mSunsetSecond, mAltitude,
        mAQI
    }
    
    override func encode() {
        super.encode()
        writeInt8(mCurrentTemperature)
        writeInt8(mMaxTemperature)
        writeInt8(mMinTemperature)
        writeInt16(mWeatherCode, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mWindSpeed)
        writeInt8(mHumidity)
        writeInt8(mVisibility)
        writeInt8(mUltraVioletIntensity)
        writeInt16(mPrecipitation, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mSunriseHour)
        writeInt8(mSunrisMinute)
        writeInt8(mSunrisSecond)
        writeInt8(mSunsetHour)
        writeInt8(mSunsetMinute)
        writeInt8(mSunsetSecond)
        // 海拔属性废弃, 如果设置了mAQI属性的值, 就使用mAQI数据发给设备
        if self.mAQI != 0 {
            writeInt16(mAQI, ByteOrder.LITTLE_ENDIAN)
        } else {
            writeInt16(mAltitude, ByteOrder.LITTLE_ENDIAN)
        }
        writeInt8(0)//保留
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleWeather2{
        
        let newModel = BleWeather2()
        if dic.keys.isEmpty {
            return newModel
        }
        newModel.mCurrentTemperature = dic["mCurrentTemperature"] as? Int ?? 0
        newModel.mMaxTemperature = dic["mMaxTemperature"] as? Int ?? 0
        newModel.mMinTemperature = dic["mMinTemperature"] as? Int ?? 0
        newModel.mWeatherCode = dic["mWeatherCode"] as? Int ?? 0
        newModel.mWindSpeed = dic["mWindSpeed"] as? Int ?? 0
        newModel.mHumidity = dic["mHumidity"] as? Int ?? 0
        newModel.mVisibility = dic["mVisibility"] as? Int ?? 0
        newModel.mUltraVioletIntensity = dic["mUltraVioletIntensity"] as? Int ?? 0
        newModel.mPrecipitation = dic["mPrecipitation"] as? Int ?? 0
        newModel.mSunriseHour = dic["mSunriseHour"] as? Int ?? 0
        newModel.mSunrisMinute = dic["mSunrisMinute"] as? Int ?? 0
        newModel.mSunrisSecond = dic["mSunrisSecond"] as? Int ?? 0
        newModel.mSunsetHour = dic["mSunsetHour"] as? Int ?? 0
        newModel.mSunsetMinute = dic["mSunsetMinute"] as? Int ?? 0
        newModel.mSunsetSecond = dic["mSunsetSecond"] as? Int ?? 0
        newModel.mAltitude = dic["mAltitude"] as? Int ?? 0
        newModel.mAQI = dic["mAQI"] as? Int ?? 0
        
        return newModel
    }
    
    /// 注意这个方法有2个, 另外一个在支持7天天气协议的地方
    /// 把天气服务code转成BLE协议中的code, 这个是我们公司的天气服务请求的数据转换对应的天气类型
    /// 其他公司使用的天气服务器需要他们单独写一个
    /// Note that there are 2 methods, the other is where the 7-day weather protocol is supported
    /// Convert the weather service code to the code in the BLE protocol, this is the weather type corresponding to the data conversion requested by our company's weather service
    /// Weather servers used by other companies need them to write a separate
    public func transformWeatherCode(code: Int) -> Int {
        var weatherCode = BleWeather.OTHER
        switch code {
        case 200, 201, 202, 210, 211, 212, 230, 231, 232:   //Group 2xx: Thunderstorm
            weatherCode = BleWeather.THUNDERSHOWER
        case 300, 301, 302, 310, 311, 312, 313, 314, 321:  //Group 3xx: Drizzle 毛毛雨
            weatherCode = BleWeather.RAINY
        case 500, 501, 502, 503, 504, 511, 520, 521, 522, 531:   //Group 5xx: Rain
            weatherCode = BleWeather.RAINY
        case 600, 601, 602, 611, 612, 613, 615, 616, 620, 621, 622:  //Group 6xx: Snow
            weatherCode = BleWeather.SNOWY
        case 701, 711, 721, 741: //Group 7xx: Atmosphere
            weatherCode = BleWeather.FOGGY
        case 731, 751, 761, 762:
            weatherCode = BleWeather.SAND_STORM
        case 771, 781: //Squall、Tornado
            weatherCode = BleWeather.HIGH_WINDY
        case 800: //Group 800: Clear 晴
            weatherCode = BleWeather.SUNNY
        case 801: //Group 80x: Clouds 阴
            weatherCode = BleWeather.OVERCAST
        case 802, 803, 804:  //多云
            weatherCode = BleWeather.CLOUDY
        default:
            weatherCode = BleWeather.OTHER
        }

        return weatherCode
    }

    open override var description: String {
        return "BleWeather2(mCurrentTemperature=\(mCurrentTemperature), mMaxTemperature=\(mMaxTemperature), " +
            "mMinTemperature=\(mMinTemperature), mWeatherCode=\(mWeatherCode), mWindSpeed=\(mWindSpeed), " +
            "mHumidity=\(mHumidity), mVisibility=\(mVisibility), mUltraVioletIntensity=\(mUltraVioletIntensity), " +
            "mPrecipitation=\(mPrecipitation), mSunriseHour=\(mSunriseHour), mSunrisMinute=\(mSunrisMinute), mSunrisSecond=\(mSunrisSecond), " +
                "mSunsetHour=\(mSunsetHour), mSunsetMinute=\(mSunsetMinute), mSunsetSecond=\(mSunsetSecond), mAltitude:\(mAltitude), mAQI:\(mAQI))"
    }
}
