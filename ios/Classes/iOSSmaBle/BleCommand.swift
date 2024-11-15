//
// Created by Best Mafen on 2019/9/24.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

// BLE协议中的command
@objc public enum BleCommand: Int, CaseIterable {
    case UPDATE = 0x01, SET = 0x02, CONNECT = 0x03, PUSH = 0x04, DATA = 0x05, CONTROL = 0x06, IO = 0x07,
         NONE = 0xff

    public var mDisplayName: String {
        String(format: "0x%02X_", rawValue) + getEnumCustomName(self)
    }
    
    private func getEnumCustomName(_ state: BleCommand) -> String {

        var name = "\(state)"
        switch state {
        case .UPDATE:
            name = "UPDATE"
        case .SET:
            name = "SET"
        case .CONNECT:
            name = "CONNECT"
        case .PUSH:
            name = "PUSH"
        case .DATA:
            name = "DATA"
        case .CONTROL:
            name = "CONTROL"
        case .IO:
            name = "IO"
        case .NONE:
            name = "NONE"
        }
    
        return name
    }

    // 获取该command对应的所有key
    public func getBleKeys() -> [BleKey] {
        BleKey.allCases.filter { bleKey in
            bleKey.mCommandRawValue == rawValue
        }
    }
}

/**
 * BLE协议中的key, key的定义包括了其对应的command，使用时直接使用key就行了
 * 增加key时，需要同步修改BleCache.requireCache()、BleCache.getIdObjects()、BleKey.isIdObjectKey()
 */
@objc public enum BleKey: Int, CaseIterable {
    // UPDATE
    case OTA = 0x0101, XMODEM = 0x0102
    
    // SET
    case TIME = 0x0201, TIME_ZONE = 0x0202, POWER = 0x0203, FIRMWARE_VERSION = 0x0204,
         BLE_ADDRESS = 0x0205, USER_PROFILE = 0x0206, STEP_GOAL = 0x0207, BACK_LIGHT = 0x0208,
         SEDENTARINESS = 0x0209, NO_DISTURB_RANGE = 0x020A, VIBRATION = 0x020B,
         GESTURE_WAKE = 0x020C, HR_ASSIST_SLEEP = 0x020D, HOUR_SYSTEM = 0x020E, LANGUAGE = 0x020F,
         ALARM = 0x0210
    /// 单位设置, 公制英制设置 0: 公制  1: 英制
    case UNIT_SETTIMG = 0x0211
    case COACHING = 0x0212,
         FIND_PHONE = 0x0213, NOTIFICATION_REMINDER = 0x0214, ANTI_LOST = 0x0215, HR_MONITORING = 0x0216,
         UI_PACK_VERSION = 0x0217, LANGUAGE_PACK_VERSION = 0x0218, SLEEP_QUALITY = 0x0219, DRINKWATER = 0x0221 , HEALTH_CARE = 0x021A,
         TEMPERATURE_DETECTING = 0x021B, AEROBIC_EXERCISE = 0x021C, TEMPERATURE_UNIT = 0x021D, DATE_FORMAT = 0x021E,
         WATCH_FACE_SWITCH = 0x021F, AGPS_PREREQUISITE = 0x0220,APP_SPORT_DATA = 0x0223, REAL_TIME_HEART_RATE = 0x0224,BLOOD_OXYGEN_SET = 0x0225, WASH_SET = 0x0226, REAL_TIME_TEMPERATURE = 0x0230,REAL_TIME_BLOOD_PRESSURE = 0x0231,
//         Temperature
         // KeyFlag为UPDATE时：设备支持外置多表盘，但是因为IO协议的限制，无法携带表盘id信息，所以在发送表盘文件之前需要先发送该指令提前告知
         //                    将要发送表盘的id
         // KeyFlag为READ时：设备支持外置多表盘，读取设备上已存在表盘id列表
         WATCHFACE_ID = 0x0227,
         IBEACON_SET = 0x0228,
         MAC_QRCODE = 0x0229,
         /// 温度标定, 手机下发当前温度标定值至设备端
         TEMPERATURE_VALUE = 0x0232,
         GAME_SET = 0x0233,
         FIND_WATCH = 0x0234,
         SET_WATCH_PASSWORD = 0x0235,
         REALTIME_MEASUREMENT = 0x0236,
         /// 省电模式
         POWER_SAVE_MODE = 0x0237,
         /// 酒精数据
         BAC = 0x0515,
         /// 比赛记录2
         MATCH_RECORD2 = 0x0516,
         /// 平均心率, 天高专用
         AVG_HEART_RATE = 0x0517,
         /// 支付宝绑定信息返回
         ALIPAY_BIND_INFO = 0x0518,
         /// 心电数据返回
         ECG = 0x0520,
         /// 鼾宝震动数据
         HANBAO_VIBRATION = 0x0521,
         /// SOS通话记录
         SOS_CALL_LOG = 0x0522,
         /// 酒精浓度检测设置
         BAC_SET = 0x0238,
         /// 酒精测试结果, 固件会主动发送
         BAC_RESULT = 0x0244,
         /// 酒精测试结果提示设置
         BAC_RESULT_SET = 0x0245,
         REALTIME_LOG = 0x02F9,
         GSENSOR_OUTPUT = 0x02FA, // G-Sensor原始数据，1开启，0关闭
         GSENSOR_RAW = 0x02FB, // G-Sensor原始数据，2^9为1g
         MOTION_DETECT = 0x02FC, // G-Sensor动作检测数据，n组√(x1 - x0)² + (y1 - y0)² + (z1 - z0)²，带符号16位整数
         LOCATION_GGA = 0x02FD, // 设备定位GGA数据
         RAW_SLEEP = 0x02FE,
         NO_DISTURB_GLOBAL = 0x02FF
    // Set
    /// 卡路里目标设置, 单位：1cal
    case CALORIES_GOAL = 0x0239
    /// 距离目标设置, 单位：1m
    case DISTANCE_GOAL = 0x023A
    /// 睡眠目标设置
    case SLEEP_GOAL = 0x023B
    /// 发送LoveTap 消息
    case LOVE_TAP = 0x0608
    /// LoveTap 联系人
    case LOVE_TAP_USER = 0x023C
    /// 吃药提醒设置
    case MEDICATION_REMINDER = 0x023D
    /// 精简的设备信息
    case DEVICE_INFO2 = 0x023E
    /// 推送, Newsfeed 消息
    case NEWS_FEER = 0x040B
    /// 目标完成进度
    case TARGET_COMPLETION = 0x040F
    /// 心率警报设置
    case HR_WARNING_SET = 0x023F
    /// 睡眠检测时间段
    case SLEEP_DETECTION_PERIOC = 0x0240
    /// 待机设置,  待机表盘
    case STANDBY_SETTING = 0x0241
    /// 吃药提醒设置2, 简化版本的吃药提醒, 类似闹钟
    case MEDICATION_ALARM = 0x0246
    /// 比赛设置
    case MATCH_SET = 0x0247
    /// 获取手表字库/UI/语言包状态信息
    case PACKAGE_STATUS = 0x0249
    /// 支付宝设置
    case ALIPAY_SET = 0x024A
    /// 音频数据传输, 手表通过这个命令key，上传给APP音频数据
    case RECORD_PACKET = 0x024B
    /// 导航数据
    case NAVI_INFO = 0x024D
    /// SOS_SET: 设置SOS,  DEVICE_LANGUAGES: 设备语言列表
    case SOS_SET = 0x024E, DEVICE_LANGUAGES = 0x024F
    
    
    /// 旧的推送协议已经满了, 无法扩展, 新增加一个
    case NOTIFICATION_REMINDER2 = 0x0250
    case GAME_TIME_REMINDER = 0x0251
    /// 手表运动中实时传输运动数据给APP
    case DEVICE_SPORT_DATA = 0x0252
    /// 压力定时测量
    case PRESSURE_TIMING_MEASUREMENT = 0x0253
    /// 定时待机表盘设置
    case STANDBY_WATCH_FACE_SET = 0x0254
    /// 设置跌落状态开关
    case FALL_SET = 0x0255
    /// 骑行和步行导航数据
    case BW_NAVI_INFO = 0x0256
    /// 连接提醒
    case CONNECT_REMINDER = 0x0257
    /// SD卡信息, 返回SD卡剩余空间等等信息
    case SDCARD_INFO = 0x0258
    /// 活动详情
    case ACTIVITY_DETAIL = 0x0259
    /// 通知亮屏提醒设置
    case NOTIFICATION_LIGHT_SCREEN_SET = 0x025A
    // 耳机相关设置
    /// 耳机电量
    case EARPHONE_POWER = 0x025D
    /// 耳机降噪设置
    case EARPHONE_ANC_SET = 0x025E
    /// 耳机音效设置
    case EARPHONE_SOUND_EFFECTS_SET = 0x025F
    /// 屏幕亮度设置
    case SCREEN_BRIGHTNESS_SET = 0x0260
    /// 耳机信息
    case EARPHONE_INFO = 0x0261
    /// 耳机状态
    case EARPHONE_STATE = 0x0262
    /// 耳机通话设置
    case EARPHONE_CALL = 0x0263
    /// GPS固件版本
    case GPS_FIRMWARE_VERSION = 0x0264
    /// GOMORE设置
    case GOMORE_SET = 0x0265
    /// 来电铃声和震动设置
    case RING_VIBRATION_SET = 0x0266
    /// 网络固件(如4G固件)版本
    case NETWORK_FIRMWARE_VERSION = 0x0267
    /// 心电定时测量设置
    case ECG_SET = 0x0268
    /// 运动时长目标
    case SPORT_DURATION_GOAL = 0x0269
    /// 表盘索引指令
    case WATCHFACE_INDEX = 0x026A
    /// SOS联系人, 最多支持5个
    case SOS_CONTACT = 0x026B
    /// 生理期月报
    case GIRL_CARE_MONTHLY = 0x026C
    /// 生理期开始和结束日修正
    case GIRL_CARE_MENSTRUATION_UPDATE = 0x026D
    /// 健康指数
    case HEALTH_INDEX = 0x026E
    /// 每日打卡
    case CHECK_INEVERY_DAY = 0x026F
    /// 佩戴方式, 0：左， 1：右
    case WEAR_WAY = 0x0270
    /// 翻腕亮屏2
    case GESTURE_WAKE2 = 0x0271
    /// 耳机按键
    case EARPHONE_KEY = 0x0272
    
    // CONNECT
    case IDENTITY = 0x0301, // 身份，代表绑定的意思
         SESSION = 0x0302, // 会话，代表登陆的意思
         PAIR = 0x0303 // 配对
    case ANCS_PAIR = 0x0304 // ancs配对
    

    // PUSH
    case MUSIC_CONTROL = 0x0402, SCHEDULE = 0x0403
    /// 推送实时天气
    case WEATHER_REALTIME = 0x0404
    /// 推送预报天气
    case WEATHER_FORECAST = 0x0405
    /// 推送实时天气 2
    case WEATHER_REALTIME2 = 0x040C
    /// 推送预报天气 2
    case WEATHER_FORECAST2 = 0x040D
    /// 在线天数
    case LOGIN_DAYS = 0x040E
         
    case WORLD_CLOCK = 0x0407,
         STOCK = 0x0408,
         // 推送快捷回复内容. 安卓实现, iOS无需实现
         SMS_QUICK_REPLY_CONTENT = 0x0409,
         /// 推送消息(带有电话号码).  安卓实现, iOS无需实现
         NOTIFICATION2 = 0x040A
    // 音频文件
    case AUDIO_TEXT = 0x0410

    // DATA
    case DATA_ALL = 0x05ff, // 实际协议中并没有该指令，该指令只是用来同步所有数据 0x050C 固件原始数据,用于固件分析使用,保存到text文件即可
         ACTIVITY_REALTIME = 0x0501,
         ACTIVITY = 0x0502, HEART_RATE = 0x0503, BLOOD_PRESSURE = 0x0504, SLEEP = 0x0505,
         WORKOUT = 0x0506, LOCATION = 0x0507, TEMPERATURE = 0x0508, BLOODOXYGEN = 0x0509,
         BLOOD_GLUCOSE = 0x0510,  /// 血糖指令
         HRV = 0x050A, LOG = 0x050B, SLEEP_RAW_DATA = 0x050C, PRESSURE = 0x050D,WORKOUT2 = 0x050E,MATCH_RECORD = 0x050F
    /// 身体状态
    case BODY_STATUS = 0x0511
    /// 心情状态
    case MIND_STATUS = 0x0512
    /// 摄入卡路里
    case CALORIE_INTAKE = 0x0513
    // 食物均衡, 饮食均衡
    case FOOD_BALANCE = 0x0514

    // CONTROL
    case CAMERA = 0x0601, PHONE_GPSSPORT = 0x0602, APP_SPORT_STATE = 0x0604, CLASSIC_BLUETOOTH_STATE = 0x0605, IBEACON_CONTROL = 0x0606, DEVICE_SMS_QUICK_REPLY = 0x0607
    /// 双击亮屏
    case DOUBLE_SCREEN = 0x060A
    /// 来电铃声
    case INCOMING_CALL_RING = 0x060C
    /// 设备结束运动的停止通知
    case SPORT_END_NOTIFY = 0x060D
    

    // IO
    case WATCH_FACE = 0x0701
    case AGPS_FILE = 0x0702
    case FONT_FILE = 0x0703
    case CONTACT = 0x0704
    case UI_FILE = 0x0705
    case MEDIA_FILE = 0x0706
    case LANGUAGE_FILE = 0x0707
    /// BrandInfo传输协议(关联蓝牙名和logo)
    case BRAND_INFO_FILE = 0x0708
    /// 发送二维码到设备
    case QRCode = 0x0709
    /// 第三方应用的通信
    case THIRD_PARTY_DATA = 0x070A
    /// 发送二维码到设备
    case QRCode2 = 0x070B
    ///自定义logo
    case CUSTOM_LOGO = 0x070C
    /// OTA固件
    case OTA_FILE = 0x070D
    /// gps固件
    case GPS_FIRMWARE_FILE = 0x070E
    /// 通讯录排序协议
    case CONTACT_SORT = 0x070F
    
    //血压标定
    case BLOOD_PRESSURE_CALIBRATION = 0x025B

    case NONE = 0xffff

    public var mDisplayName: String {
        String(format: "0x%04X_", rawValue) + getEnumCustomName(self)
    }

    var mBleCommand: BleCommand {
        if let command = BleCommand(rawValue: (rawValue >> 8) & 0xff) {
            return command
        } else {
            return BleCommand.NONE
        }
    }

    var mCommandRawValue: UInt8 {
        UInt8((rawValue >> 8) & 0xff)
    }

    var mKeyRawValue: UInt8 {
        UInt8(rawValue & 0xff)
    }

    public func getBleKeyFlags() -> [BleKeyFlag] {
        switch self {
            // UPDATE
        case .OTA, .XMODEM:
            return [.UPDATE]
            // SET
        case .FIND_PHONE:
            return [.UPDATE]
        case .POWER, .FIRMWARE_VERSION, .BLE_ADDRESS, .UI_PACK_VERSION, .LANGUAGE_PACK_VERSION, .DEVICE_LANGUAGES:
            return [.READ]
        case .NOTIFICATION_REMINDER, .SLEEP_QUALITY, .TEMPERATURE_DETECTING, .APP_SPORT_DATA, .REAL_TIME_HEART_RATE,.WASH_SET,.GAME_SET, .FIND_WATCH,.REALTIME_MEASUREMENT, .TEMPERATURE_VALUE, .STANDBY_SETTING, .WEAR_WAY:
            return [.UPDATE]
        case .GESTURE_WAKE, .GESTURE_WAKE2, .EARPHONE_KEY:
            return [.UPDATE, .READ]
        case .DRINKWATER: // 抬手亮屏  DRINKWATER: 喝水提醒不支持Read
            return [.UPDATE] // 这个指令, 是可以接受设备的回调的, 设备设置抬手亮屏后, 会告诉APP设置的数据
        case .RECORD_PACKET:
            return [.UPDATE]
        case .TIME, .TIME_ZONE, .USER_PROFILE, .STEP_GOAL, .BACK_LIGHT, .SEDENTARINESS,
             .NO_DISTURB_RANGE, .WATCH_FACE_SWITCH, .NO_DISTURB_GLOBAL, .AEROBIC_EXERCISE, .VIBRATION, .HR_ASSIST_SLEEP, .TEMPERATURE_UNIT, .DATE_FORMAT,
             .HOUR_SYSTEM, .LANGUAGE, .ANTI_LOST, .HR_MONITORING, .WATCHFACE_ID,.IBEACON_SET,.MAC_QRCODE, .SET_WATCH_PASSWORD, .SOS_SET, .HEALTH_CARE,.DOUBLE_SCREEN, .INCOMING_CALL_RING, .BLOOD_OXYGEN_SET, .NOTIFICATION_REMINDER2,.BLOOD_PRESSURE_CALIBRATION:
            return [.UPDATE, .READ]
        case .RAW_SLEEP, .DEVICE_INFO2, .PACKAGE_STATUS:
            return [.READ]
        case .CALORIES_GOAL, .DISTANCE_GOAL, .SLEEP_GOAL:
            return [.READ]
        case .ALARM, .MEDICATION_REMINDER, .MEDICATION_ALARM:
            return [.CREATE, .DELETE, .UPDATE, .READ, .RESET]
        case .COACHING:
            return [.CREATE, .UPDATE, .READ]
            // CONNECT
        case .IDENTITY, .DEVICE_SMS_QUICK_REPLY:
            return [.CREATE, .READ, .DELETE]
        case .PAIR:
            return [.UPDATE, .READ]
            // PUSH
        case .SCHEDULE:
            return [.CREATE, .DELETE, .UPDATE]
        case .WEATHER_REALTIME, .WEATHER_FORECAST, .WEATHER_REALTIME2, .WEATHER_FORECAST2, .LOGIN_DAYS, .TARGET_COMPLETION, .HR_WARNING_SET:
            return [.UPDATE]
        case .WORLD_CLOCK, .STOCK:
            return [.CREATE, .UPDATE, .READ,.DELETE]
            // DATA
        case .DATA_ALL, .ACTIVITY_REALTIME:
            return [.READ]
        case .ACTIVITY, .HEART_RATE, .BLOOD_PRESSURE, .SLEEP, .WORKOUT, .LOCATION, .TEMPERATURE, .BLOODOXYGEN, .HRV, .SLEEP_RAW_DATA, .PRESSURE, .WORKOUT2, .MATCH_RECORD, .BLOOD_GLUCOSE:
            return [.READ, .DELETE]
        case .BODY_STATUS, .MIND_STATUS, .CALORIE_INTAKE, .FOOD_BALANCE:
            return [.READ]
            
            // CONTROL
        case .CAMERA, .APP_SPORT_STATE,.IBEACON_CONTROL:
            return [.UPDATE]
        case .CLASSIC_BLUETOOTH_STATE:
            return [.READ, .UPDATE]
            // IO
        case .CONTACT:
            return [.UPDATE, .DELETE]
        case .WATCH_FACE, .AGPS_FILE, .FONT_FILE, .UI_FILE, .LANGUAGE_FILE, .BRAND_INFO_FILE, .QRCode, .QRCode2, .CUSTOM_LOGO, .THIRD_PARTY_DATA, .BW_NAVI_INFO, .CONNECT_REMINDER, .OTA_FILE, .GPS_FIRMWARE_FILE, .CONTACT_SORT:
            return [.UPDATE]
        case .POWER_SAVE_MODE, .PRESSURE_TIMING_MEASUREMENT, .STANDBY_WATCH_FACE_SET, .FALL_SET: // 省电模式
            return [.UPDATE, .READ]
        case .BAC, .AVG_HEART_RATE, .SDCARD_INFO, .ACTIVITY_DETAIL, .ECG, .HANBAO_VIBRATION, .GIRL_CARE_MONTHLY, .SOS_CALL_LOG: // 酒精数据
            return [.READ]
        case .NOTIFICATION_LIGHT_SCREEN_SET, .ECG_SET, .CHECK_INEVERY_DAY: // 通知亮屏提醒设置
            return [.READ, .UPDATE]
        case .ALIPAY_BIND_INFO: // 支付宝激活信息返回
            return [.READ, .DELETE]
        case .BAC_SET, .BAC_RESULT_SET, .SPORT_DURATION_GOAL: // 酒精浓度检测设置
            return [.UPDATE]
        case .WATCHFACE_INDEX, .SOS_CONTACT, .GIRL_CARE_MENSTRUATION_UPDATE, .HEALTH_INDEX:
            return [.UPDATE]
        default:
            return []
        }
    }

    func isIdObjectKey() -> Bool {
        self == .ALARM || self == .SCHEDULE || self == .COACHING || self == .WORLD_CLOCK || self == .STOCK || self == .LOVE_TAP_USER
    }
    
    private func getEnumCustomName(_ key: BleKey) -> String {

        var name = "\(key)"
        switch key {
        case .OTA:
            name = "OTA"
        case .XMODEM:
            name = "XMODEM"
        case .TIME:
            name = "TIME"
        case .TIME_ZONE:
            name = "TIME_ZONE"
        case .POWER:
            name = "POWER"
        case .FIRMWARE_VERSION:
            name = "FIRMWARE_VERSION"
        case .BLE_ADDRESS:
            name = "BLE_ADDRESS"
        case .USER_PROFILE:
            name = "USER_PROFILE"
        case .NONE:
            name = "NONE"
        case .STEP_GOAL:
            name = "STEP_GOAL"
        case .BACK_LIGHT:
            name = "BACK_LIGHT"
        case .SEDENTARINESS:
            name = "SEDENTARINESS"
        case .NO_DISTURB_RANGE:
            name = "NO_DISTURB_RANGE"
        case .VIBRATION:
            name = "VIBRATION"
        case .GESTURE_WAKE:
            name = "GESTURE_WAKE"
        case .HR_ASSIST_SLEEP:
            name = "HR_ASSIST_SLEEP"
        case .HOUR_SYSTEM:
            name = "HOUR_SYSTEM"
        case .LANGUAGE:
            name = "LANGUAGE"
        case .ALARM:
            name = "ALARM"
        case .UNIT_SETTIMG:
            name = "UNIT_SETTIMG"
        case .COACHING:
            name = "COACHING"
        case .FIND_PHONE:
            name = "FIND_PHONE"
        case .NOTIFICATION_REMINDER:
            name = "NOTIFICATION_REMINDER"
        case .ANTI_LOST:
            name = "ANTI_LOST"
        case .HR_MONITORING:
            name = "HR_MONITORING"
        case .UI_PACK_VERSION:
            name = "UI_PACK_VERSION"
        case .LANGUAGE_PACK_VERSION:
            name = "LANGUAGE_PACK_VERSION"
        case .SLEEP_QUALITY:
            name = "SLEEP_QUALITY"
        case .DRINKWATER:
            name = "DRINKWATER"
        case .HEALTH_CARE:
            name = "HEALTH_CARE"
        case .TEMPERATURE_DETECTING:
            name = "TEMPERATURE_DETECTING"
        case .AEROBIC_EXERCISE:
            name = "AEROBIC_EXERCISE"
        case .TEMPERATURE_UNIT:
            name = "TEMPERATURE_UNIT"
        case .DATE_FORMAT:
            name = "DATE_FORMAT"
        case .WATCH_FACE_SWITCH:
            name = "WATCH_FACE_SWITCH"
        case .AGPS_PREREQUISITE:
            name = "AGPS_PREREQUISITE"
        case .APP_SPORT_DATA:
            name = "APP_SPORT_DATA"
        case .REAL_TIME_HEART_RATE:
            name = "REAL_TIME_HEART_RATE"
        case .BLOOD_OXYGEN_SET:
            name = "BLOOD_OXYGEN_SET"
        case .WASH_SET:
            name = "WASH_SET"
        case .REAL_TIME_TEMPERATURE:
            name = "REAL_TIME_TEMPERATURE"
        case .REAL_TIME_BLOOD_PRESSURE:
            name = "REAL_TIME_BLOOD_PRESSURE"
        case .WATCHFACE_ID:
            name = "WATCHFACE_ID"
        case .IBEACON_SET:
            name = "IBEACON_SET"
        case .MAC_QRCODE:
            name = "MAC_QRCODE"
        case .TEMPERATURE_VALUE:
            name = "TEMPERATURE_VALUE"
        case .GAME_SET:
            name = "GAME_SET"
        case .FIND_WATCH:
            name = "FIND_WATCH"
        case .SET_WATCH_PASSWORD:
            name = "SET_WATCH_PASSWORD"
        case .REALTIME_MEASUREMENT:
            name = "REALTIME_MEASUREMENT"
        case .POWER_SAVE_MODE:
            name = "POWER_SAVE_MODE"
        case .BAC:
            name = "BAC"
        case .MATCH_RECORD2:
            name = "MATCH_RECORD2"
        case .AVG_HEART_RATE:
            name = "AVG_HEART_RATE"
        case .ALIPAY_BIND_INFO:
            name = "ALIPAY_BIND_INFO"
        case .ECG:
            name = "ECG"
        case .HANBAO_VIBRATION:
            name = "HANBAO_VIBRATION"
        case .SOS_CALL_LOG:
            name = "SOS_CALL_LOG"
        case .BAC_SET:
            name = "BAC_SET"
        case .BAC_RESULT:
            name = "BAC_RESULT"
        case .BAC_RESULT_SET:
            name = "BAC_RESULT_SET"
        case .REALTIME_LOG:
            name = "REALTIME_LOG"
        case .GSENSOR_OUTPUT:
            name = "GSENSOR_OUTPUT"
        case .GSENSOR_RAW:
            name = "GSENSOR_RAW"
        case .MOTION_DETECT:
            name = "MOTION_DETECT"
        case .LOCATION_GGA:
            name = "LOCATION_GGA"
        case .RAW_SLEEP:
            name = "RAW_SLEEP"
        case .NO_DISTURB_GLOBAL:
            name = "NO_DISTURB_GLOBAL"
        case .CALORIES_GOAL:
            name = "CALORIES_GOAL"
        case .DISTANCE_GOAL:
            name = "DISTANCE_GOAL"
        case .SLEEP_GOAL:
            name = "SLEEP_GOAL"
        case .LOVE_TAP:
            name = "LOVE_TAP"
        case .LOVE_TAP_USER:
            name = "LOVE_TAP_USER"
        case .MEDICATION_REMINDER:
            name = "MEDICATION_REMINDER"
        case .DEVICE_INFO2:
            name = "DEVICE_INFO2"
        case .NEWS_FEER:
            name = "NEWS_FEER"
        case .TARGET_COMPLETION:
            name = "TARGET_COMPLETION"
        case .HR_WARNING_SET:
            name = "HR_WARNING_SET"
        case .SLEEP_DETECTION_PERIOC:
            name = "SLEEP_DETECTION_PERIOC"
        case .STANDBY_SETTING:
            name = "STANDBY_SETTING"
        case .MEDICATION_ALARM:
            name = "MEDICATION_ALARM"
        case .MATCH_SET:
            name = "MATCH_SET"
        case .PACKAGE_STATUS:
            name = "PACKAGE_STATUS"
        case .ALIPAY_SET:
            name = "ALIPAY_SET"
        case .RECORD_PACKET:
            name = "RECORD_PACKET"
        case .NAVI_INFO:
            name = "NAVI_INFO"
        case .SOS_SET:
            name = "SOS_SET"
        case .DEVICE_LANGUAGES:
            name = "DEVICE_LANGUAGES"
        case .NOTIFICATION_REMINDER2:
            name = "NOTIFICATION_REMINDER2"
        case .GAME_TIME_REMINDER:
            name = "GAME_TIME_REMINDER"
        case .DEVICE_SPORT_DATA:
            name = "DEVICE_SPORT_DATA"
        case .PRESSURE_TIMING_MEASUREMENT:
            name = "PRESSURE_TIMING_MEASUREMENT"
        case .STANDBY_WATCH_FACE_SET:
            name = "STANDBY_WATCH_FACE_SET"
        case .FALL_SET:
            name = "FALL_SET"
        case .BW_NAVI_INFO:
            name = "BW_NAVI_INFO"
        case .CONNECT_REMINDER:
            name = "CONNECT_REMINDER"
        case .SDCARD_INFO:
            name = "SDCARD_INFO"
        case .ACTIVITY_DETAIL:
            name = "ACTIVITY_DETAIL"
        case .NOTIFICATION_LIGHT_SCREEN_SET:
            name = "NOTIFICATION_LIGHT_SCREEN_SET"
        case .EARPHONE_POWER:
            name = "EARPHONE_POWER"
        case .EARPHONE_ANC_SET:
            name = "EARPHONE_ANC_SET"
        case .EARPHONE_SOUND_EFFECTS_SET:
            name = "EARPHONE_SOUND_EFFECTS_SET"
        case .SCREEN_BRIGHTNESS_SET:
            name = "SCREEN_BRIGHTNESS_SET"
        case .EARPHONE_INFO:
            name = "EARPHONE_INFO"
        case .EARPHONE_STATE:
            name = "EARPHONE_STATE"
        case .EARPHONE_CALL:
            name = "EARPHONE_CALL"
        case .GPS_FIRMWARE_VERSION:
            name = "GPS_FIRMWARE_VERSION"
        case .GOMORE_SET:
            name = "GOMORE_SET"
        case .RING_VIBRATION_SET:
            name = "RING_VIBRATION_SET"
        case .NETWORK_FIRMWARE_VERSION:
            name = "NETWORK_FIRMWARE_VERSION"
        case .ECG_SET:
            name = "ECG_SET"
        case .SPORT_DURATION_GOAL:
            name = "SPORT_DURATION_GOAL"
        case .WATCHFACE_INDEX:
            name = "WATCHFACE_INDEX"
        case .SOS_CONTACT:
            name = "SOS_CONTACT"
        case .GIRL_CARE_MONTHLY:
            name = "GIRL_CARE_MONTHLY"
        case .GIRL_CARE_MENSTRUATION_UPDATE:
            name = "GIRL_CARE_MENSTRUATION_UPDATE"
        case .HEALTH_INDEX:
            name = "HEALTH_INDEX"
        case .CHECK_INEVERY_DAY:
            name = "CHECK_INEVERY_DAY"
        case .WEAR_WAY:
            name = "WEAR_WAY"
        case .GESTURE_WAKE2:
            name = "GESTURE_WAKE2"
        case .EARPHONE_KEY:
            name = "EARPHONE_KEY"
        case .IDENTITY:
            name = "IDENTITY"
        case .SESSION:
            name = "SESSION"
        case .PAIR:
            name = "PAIR"
        case .ANCS_PAIR:
            name = "ANCS_PAIR"
        case .MUSIC_CONTROL:
            name = "MUSIC_CONTROL"
        case .SCHEDULE:
            name = "SCHEDULE"
        case .WEATHER_REALTIME:
            name = "WEATHER_REALTIME"
        case .WEATHER_FORECAST:
            name = "WEATHER_FORECAST"
        case .WEATHER_REALTIME2:
            name = "WEATHER_REALTIME2"
        case .WEATHER_FORECAST2:
            name = "WEATHER_FORECAST2"
        case .LOGIN_DAYS:
            name = "LOGIN_DAYS"
        case .WORLD_CLOCK:
            name = "WORLD_CLOCK"
        case .STOCK:
            name = "STOCK"
        case .SMS_QUICK_REPLY_CONTENT:
            name = "SMS_QUICK_REPLY_CONTENT"
        case .NOTIFICATION2:
            name = "NOTIFICATION2"
        case .AUDIO_TEXT:
            name = "AUDIO_TEXT"
        case .DATA_ALL:
            name = "DATA_ALL"
        case .ACTIVITY_REALTIME:
            name = "ACTIVITY_REALTIME"
        case .ACTIVITY:
            name = "ACTIVITY"
        case .HEART_RATE:
            name = "HEART_RATE"
        case .BLOOD_PRESSURE:
            name = "BLOOD_PRESSURE"
        case .SLEEP:
            name = "SLEEP"
        case .WORKOUT:
            name = "WORKOUT"
        case .LOCATION:
            name = "LOCATION"
        case .TEMPERATURE:
            name = "TEMPERATURE"
        case .BLOODOXYGEN:
            name = "BLOODOXYGEN"
        case .BLOOD_GLUCOSE:
            name = "BLOOD_GLUCOSE"
        case .HRV:
            name = "HRV"
        case .LOG:
            name = "LOG"
        case .SLEEP_RAW_DATA:
            name = "SLEEP_RAW_DATA"
        case .PRESSURE:
            name = "PRESSURE"
        case .WORKOUT2:
            name = "WORKOUT2"
        case .MATCH_RECORD:
            name = "MATCH_RECORD"
        case .BODY_STATUS:
            name = "BODY_STATUS"
        case .MIND_STATUS:
            name = "MIND_STATUS"
        case .CALORIE_INTAKE:
            name = "CALORIE_INTAKE"
        case .FOOD_BALANCE:
            name = "FOOD_BALANCE"
        case .CAMERA:
            name = "CAMERA"
        case .PHONE_GPSSPORT:
            name = "PHONE_GPSSPORT"
        case .APP_SPORT_STATE:
            name = "APP_SPORT_STATE"
        case .CLASSIC_BLUETOOTH_STATE:
            name = "CLASSIC_BLUETOOTH_STATE"
        case .IBEACON_CONTROL:
            name = "IBEACON_CONTROL"
        case .DEVICE_SMS_QUICK_REPLY:
            name = "DEVICE_SMS_QUICK_REPLY"
        case .DOUBLE_SCREEN:
            name = "DOUBLE_SCREEN"
        case .INCOMING_CALL_RING:
            name = "INCOMING_CALL_RING"
        case .SPORT_END_NOTIFY:
            name = "SPORT_END_NOTIFY"
        case .WATCH_FACE:
            name = "WATCH_FACE"
        case .AGPS_FILE:
            name = "AGPS_FILE"
        case .FONT_FILE:
            name = "FONT_FILE"
        case .CONTACT:
            name = "CONTACT"
        case .UI_FILE:
            name = "UI_FILE"
        case .MEDIA_FILE:
            name = "MEDIA_FILE"
        case .LANGUAGE_FILE:
            name = "LANGUAGE_FILE"
        case .BRAND_INFO_FILE:
            name = "BRAND_INFO_FILE"
        case .QRCode:
            name = "QRCode"
        case .THIRD_PARTY_DATA:
            name = "THIRD_PARTY_DATA"
        case .QRCode2:
            name = "QRCode2"
        case .CUSTOM_LOGO:
            name = "CUSTOM_LOGO"
        case .OTA_FILE:
            name = "OTA_FILE"
        case .GPS_FIRMWARE_FILE:
            name = "GPS_FIRMWARE_FILE"
        case .CONTACT_SORT:
            name = "CONTACT_SORT"
        case .BLOOD_PRESSURE_CALIBRATION:
            name = "BLOOD_PRESSURE_CALIBRATION"
        }
    
        return name
    }
}

@objc public enum BleKeyFlag: Int {
    case UPDATE = 0x00, READ = 0x10, READ_CONTINUE = 0x11, CREATE = 0x20, DELETE = 0x30,
         // BleIdObject专属，相当于Delete All和Create的组合，用于绑定时重置BleIdObject列表
         // 只能用BleConnector.sendArray重置，sendObject无效
         RESET = 0x40,
         NONE = 0xff

    public var mDisplayName: String {
        String(format: "0x%02X_", rawValue) + getEnumCustomName(self)
    }
    
    private func getEnumCustomName(_ state: BleKeyFlag) -> String {

        var name = "\(state)"
        switch state {
        case .UPDATE:
            name = "UPDATE"
        case .READ:
            name = "READ"
        case .READ_CONTINUE:
            name = "READ_CONTINUE"
        case .CREATE:
            name = "CREATE"
        case .DELETE:
            name = "DELETE"
        case .RESET:
            name = "RESET"
        case .NONE:
            name = "NONE"
        }
    
        return name
    }
}
