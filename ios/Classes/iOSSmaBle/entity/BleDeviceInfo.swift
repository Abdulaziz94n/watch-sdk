//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleDeviceInfo: BleReadable {
    public static let PLATFORM_NORDIC = "Nordic"
    public static let PLATFORM_REALTEK = "Realtek"
    public static let PLATFORM_MTK = "MTK"
    public static let PLATFORM_GOODIX = "Goodix"
    public static let PLATFORM_JL = "JL"//杰里
    public static let PLATFORM_SIFLI = "SIFLI"
    public static let PLATFORM_ZKLX = "ZKLX"
    public static let PLATFORM_JL707 = "JL707"

    // Nordic
    public static let PROTOTYPE_10G = "SMA-10G"
    public static let PROTOTYPE_GTM5 = "SMA-GTM5"
    public static let PROTOTYPE_F1N = "SMA-F1N"
    public static let PROTOTYPE_ND09 = "SMA-ND09"
    public static let PROTOTYPE_ND08 = "SMA-ND08"
    public static let PROTOTYPE_FA86 = "SMA_FA_86"
    public static let PROTOTYPE_MC11 = "SMA_MC_11"

    // Realtek
    public static let PROTOTYPE_R4 = "SMA-R4"
    public static let PROTOTYPE_R5 = "SMA-R5"
    public static let PROTOTYPE_F1RT = "SMA-F1RT"
    public static let PROTOTYPE_F2 = "SMA-F2"
    public static let PROTOTYPE_F3C = "SMA-F3C"
    public static let PROTOTYPE_F3R = "SMA-F3R"
    public static let PROTOTYPE_F3L = "F3-LH"
    public static let PROTOTYPE_R7 = "SMA-R7"
    public static let PROTOTYPE_F13 = "SMA-F13"
    public static let PROTOTYPE_F13J = "F13J"
    public static let PROTOTYPE_B5CRT = "SMA-B5CRT"
    public static let PROTOTYPE_R10 = "R10"
    public static let PROTOTYPE_R10Pro = "R10Pro"
    public static let PROTOTYPE_R11 = "R11"
    public static let PROTOTYPE_R11S = "R11S"
    public static let PROTOTYPE_F5 = "F5"
    public static let PROTOTYPE_F6 = "F6"
    public static let PROTOTYPE_F7 = "F7"
    public static let PROTOTYPE_F9 = "F9"
    public static let PROTOTYPE_R9 = "R9"
    public static let PROTOTYPE_SW01 = "SMA-SW01"
    public static let PROTOTYPE_F2R = "SMA-F2R"
    public static let PROTOTYPE_GTM5R = "REALTEK_GTM5"
    public static let PROTOTYPE_F1 = "SMA-F1"
    public static let PROTOTYPE_F2D = "SMA-F2D"
    public static let PROTOTYPE_T78 = "T78"
    public static let PROTOTYPE_SMAV1 = "SMA-V1"
    public static let PROTOTYPE_Y1 = "Y1"
    public static let PROTOTYPE_Y2 = "Y2"
    public static let PROTOTYPE_V2 = "V2"
    public static let PROTOTYPE_Y3 = "Y3"
    public static let PROTOTYPE_R3Pro = "R3Pro"
    public static let PROTOTYPE_F2Pro = "F2Pro"
    public static let PROTOTYPE_Match_S1 = "Match_S1"
    public static let PROTOTYPE_S2 = "S2"
    public static let PROTOTYPE_S03 = "SMA_S03"
    public static let PROTOTYPE_B9 = "B9"
    public static let PROTOTYPE_V5  = "V5"
    public static let PROTOTYPE_V3  = "V3"
    public static let PROTOTYPE_LG19T = "LG19T"
    public static let PROTOTYPE_F2K = "F2K"
    public static let PROTOTYPE_W9 = "W9"
    public static let PROTOTYPE_Explorer = "Explorer"
    public static let PROTOTYPE_NY58 = "NY58"
    public static let PROTOTYPE_F12 = "F12"
    public static let PROTOTYPE_AM01 = "AM01"
    public static let PROTOTYPE_F11 = "F11"
    public static let PROTOTYPE_F13A = "F13A"
    public static let PROTOTYPE_F2R_NEW = "F2R"
    public static let PROTOTYPE_F1_NEW = "F1"
    public static let PROTOTYPE_S4 = "S4"
    public static let PROTOTYPE_R6_PRO_DK = "R6_PRO_DK"
    public static let PROTOTYPE_GB1 = "GB1" /// 这个设备有点特殊, 仅仅需要OTA即可, 其他都不要, 所以开发需要注意下
    public static let PROTOTYPE_SPORT4 = "Sport4"
    
    // Goodix
    public static let PROTOTYPE_R3H = "R3H"
    public static let PROTOTYPE_R3Q = "R3Q"

    // MTK
    public static let PROTOTYPE_R2 = "R2"
    public static let PROTOTYPE_F3 = "F3"
    public static let PROTOTYPE_M3 = "M3"
    public static let PROTOTYPE_M4 = "M4"
    public static let PROTOTYPE_M4C = "M4C"
    public static let PROTOTYPE_M5C = "M5C"
    public static let PROTOTYPE_M4S = "M4S"
    public static let PROTOTYPE_M7 = "M7"
    public static let PROTOTYPE_M7S = "M7S"
    public static let PROTOTYPE_M6 = "M6"
    public static let PROTOTYPE_M6C = "M6C"
    public static let PROTOTYPE_M7C = "M7C"
    // JL
    public static let PROTOTYPE_R9J = "R9J"
    public static let PROTOTYPE_F13B = "F13B"
    public static let PROTOTYPE_A7 = "A7"
    public static let PROTOTYPE_A8 = "A8"
    public static let PROTOTYPE_AM01J = "AM01J"
    public static let PROTOTYPE_F17 = "F17"
    public static let PROTOTYPE_AM02J = "AM02J"
    public static let PROTOTYPE_HW01 = "HW01"
    public static let PROTOTYPE_F12Pro = "F12Pro"
    public static let PROTOTYPE_K18 = "K18"
    public static let PROTOTYPE_AW12 = "AW12"
    public static let PROTOTYPE_AM05 = "AM05"
    public static let PROTOTYPE_K30 = "K30"
    public static let PROTOTYPE_FC1 = "FC1"
    public static let PROTOTYPE_FC2 = "FC2"
    public static let PROTOTYPE_F6Pro = "F6Pro"
    public static let PROTOTYPE_FT5 = "FT5"
    public static let PROTOTYPE_R16 = "R16"
    public static let PROTOTYPE_A8_Ultra_Pro = "A8_Ultra_Pro"
    public static let PROTOTYPE_AM08 = "AM08"
    public static let PROTOTYPE_JX621D = "JX621D"
    public static let PROTOTYPE_V61 = "V61"
    public static let PROTOTYPE_AM11 = "AM11"
    public static let PROTOTYPE_AW37 = "AW37"
    public static let PROTOTYPE_WS001 = "WS001"
    public static let PROTOTYPE_B9C_JL = "B9C_JL"
    public static let PROTOTYPE_A9mini = "A9mini"
    public static let PROTOTYPE_AM25 = "AM25"
    public static let PROTOTYPE_AM22 = "AM22"
    
    //MARK: JL平台, 耳机设备
    public static let PROTOTYPE_X3 = "X3"
    
    /// 思澈平台的原型
    public static let PROTOTYPE_SF15GUC = "SF15GUC"
    
    public static let AGPS_NONE = 0 // 无GPS芯片
    public static let AGPS_EPO = 1 // MTK EPO
    public static let AGPS_UBLOX = 2
    public static let AGPS_AGNSS = 6 // 中科微
    public static let AGPS_EPO_ONLY  = 7 //MTK EPO
    public static let AGPS_LTO = 8
    public static let AGPS_6228 = 9

    public static let WATCH_FACE_NONE = 0 // 不支持表盘
    public static let WATCH_FACE_10G = 1
    public static let WATCH_FACE_F3 = 2   //sma通用表盘-MTK 240x240-旧表盘
    public static let WATCH_FACE_REALTEK = 3 //Realtek bmp格式表盘 方形
    public static let WATCH_FACE_240x280 = 4    //MTK-小尺寸表盘 要求表盘文件不超过40K
    public static let WATCH_FACE_320x385 = 5    //MTK-表盘文件分辨率320x385
    public static let WATCH_FACE_320x363 = 6    //MTK-表盘文件分辨率320x363
    public static let WATCH_FACE_REALTEK_ROUND = 7 //Realtek bmp格式表盘 圆形
    public static let WATCH_FACE_GOODIX = 8 //汇顶平台表盘
    public static let WATCH_FACE_REALTEK_RACKET = 9    //瑞昱R6,R8球拍屏，240x240
    public static let WATCH_FACE_REALTEK_SQUARE_240x280 = 10  //瑞昱240*280方形表盘BMP格式
    public static let WATCH_FACE_REALTEK_ROUND_240x240 = 11 //瑞昱bmp格式表盘,圆形表盘文件分辨率240*240，双模蓝牙
    public static let WATCH_FACE_REALTEK_SQUARE_240x240 = 12 //瑞昱bmp格式表盘，方形表盘 240*240 双模蓝牙
    public static let WATCH_FACE_240_240 = 13   //MTK 240x240-新表盘
    public static let WATCH_FACE_REALTEK_SQUARE_80x160 = 14 //瑞昱80*160方形表盘BMP格式
    public static let WATCH_FACE_REALTEK_ROUND_360x360 = 15 //BMP 圆形-目前应用于瑞昱平台
    public static let WATCH_FACE_REALTEK_SQUARE_240x280_2 = 16 //瑞昱240*280方形表盘BMP格式（双蓝牙）
    public static let WATCH_FACE_REALTEK_ROUND_454x454 = 17 //瑞昱 454x454 圆形 双蓝牙 R9 （中间件项目，表盘需字节对齐）
    public static let WATCH_FACE_REALTEK_ROUND_CENTER_240x240 = 18 //瑞昱 240x240 圆形 单蓝牙 GTM5（中间件项目，表盘需字节对齐)
    public static let WATCH_FACE_REALTEK_SQUARE_240x280_19 = 19 //标记10扩展 瑞昱240*280方形表盘BMP格式（单蓝牙）
    public static let WATCH_FACE_REALTEK_SQUARE_240x280_20 = 20 //标记10扩展 瑞昱240*280方形表盘BMP格式（双蓝牙）
    public static let WATCH_FACE_REALTEK_SQUARE_240x295_21 = 21 //瑞昱240*295方形表盘BMP格式（双蓝牙）
    public static let WATCH_FACE_SERVER  = 99 //服务器表盘标记位
    
    /// 自定义蓝牙名后, 用于查找原始名称的分隔符
    private let kRAW_NAME_SEPARATOR = "<>"
    
    private(set) public var mId: Int = 0

    /**
     * 设备支持读取的数据列表。
     */
    private(set) public var mDataKeys: [Int] = []

    /**
     * 设备蓝牙名。
     */
    private(set) public var mBleName: String = ""
    /**
     * 用户自定义的蓝牙名
     */
    private(set) public var mBleCustomName: String = ""

    /**
     * 设备蓝牙4.0地址。
     */
    private(set) public var mBleAddress: String = ""

    /**
     * 芯片平台，Nordic、RealTek、MTK,、Goodix等。
     */
    private(set) public var mPlatform: String = ""

    /**
     * 设备原型，代表是基于哪款设备开发。
     */
    private(set) public  var mPrototype: String = ""

    /**
     * 固件标记，固件那边所说的制造商，但严格来说，制造商表述并不恰当，且避免与后台数据结构中的分销商语义冲突，
     * 因为其仅仅用来区分固件，所以命名为FirmwareFlag，与BleName联合确定唯一固件。
     */
    private(set) public  var mFirmwareFlag: String = ""

    /**
     * aGps文件类型，不同读GPS芯片需要下载不同的aGps文件，AGPS_EPO、AGPS_UBLOX或AGPS_AGNSS等，
     * 如果为0，代表不支持GPS。
     */
    private(set) public var mAGpsType: Int = 0 // aGps文件类型

    /**
     * 发送BleCommand.IO的Buffer大小，见BleConnector.sendStream。
     */
    var mIOBufferSize: Int = 0

    /**
     * 表盘类型，WATCH_FACE_10G或WATCH_FACE_F3。
     */
    private(set) public var mWatchFaceType: Int = 0

    /**
     * 设备蓝牙3.0地址。
     */
    private(set) public var mClassicAddress: String = ""

    /**
     * 不显示数字电量。
     */
    private(set) public var mHideDigitalPower: Int = 0

    /**
     * 显示防丢开关。
     */
    private(set) public var mAntiLostSwitch: Int = 0

    /**
     * 新睡眠算法
     */
    private(set) public var mSleepAlgorithmType: Int = 0

    /**
     * 日期格式修改
     */
    private(set) public var mDateFormat: Int = 0

    private(set) public var mSupportReadDeviceInfo: Int = 0
    /**
     * 是否支持修改体温单位
     */
    private(set) public var mTemperatureUnit : Int = 0
    /**
     * 是否支持喝水提醒设置
     */
    private(set) public var mDrinkWater : Int = 0
    /**
     * 是否支持3.0协议
     */
    private(set) public var mChangeClassicBluetoothState : Int = 0
    /**
     * 是否支持App、手表运动模式联动协议
     */
    private(set) public var mAppSport : Int = 0
    /**
     * 是否支持血氧定时监测设置
     */
    private(set) public var mBloodOxyGenSet : Int = 0
    /**
     * 是否支持洗手提醒的设置
     */
    private(set) public var mWashSet : Int = 0
    /**
     * 是否支持按需更新天气
     */
    private(set) public var mDemandWeather : Int = 0
    /**
     * 是否支持HID协议
     */
    private(set) public var mSupportHID : Int = 0
    /**
     * 是否支持iBeacon协议
     */
    private(set) public var miBeacon : Int = 0
    /**
     * 是否支持设置表盘ID
     */
    private(set) public var mSupportWatchFaceId : Int = 0
    /**
     * 是否支持IOS withoutResponse传输
     */
    private(set) public var mSupportNewTransportMode : Int = 0
    /**
     * 是否支持杰里SDK传输表盘
     */
    private(set) public var mSupportJLWatchFace : Int = 0
    /**
     * 是否支持找手表
     */
    private(set) public var mSupportFindWatch : Int = 0
    /**
     * 是否支持世界时钟
     */
    private(set) public var mSupportWorldClock : Int = 0
    /**
     * 是否支持股票
     */
    private(set) public var mSupportStock : Int = 0
    /**
     * 是否支持快捷短信回复(Android使用)
     */
    private(set) public var mSupportSMSQuickReply : Int = 0
    /**
     * 是否App勿扰时间段
     */
    private(set) public var mSupportNoDisturbSet : Int = 0
    /**
     * 设备是否支持设置密码
     */
    private(set) public var mSupportSetWatchPassword : Int = 0
    /**
     * 设备是否支持实时测量心率、血压、血氧
     */
    private(set) public var mSupportRealTimeMeasurement : Int = 0
    /**
     * 设备是否支持是否支持省电模式功能
     */
    private(set) public var mSupportPowerSaveMode: Int = 0
    
    /// 设备是否支持是否支持LoveTap功能
    private(set) public var mSupportLoveTap: Int = 0
    
    /// 设备是否支持是否支持Newsfeed功能
    private(set) public var mSupportNewsfeed: Int = 0
    
    /// 设备是否支持是否支持吃药提醒, [SUPPORT_MEDICATION_REMINDER_0], [SUPPORT_MEDICATION_REMINDER_1]
    private(set) public var mSupportMedicationReminder: Int = 0
    /// 设备是否支持是否同步二维码, [SUPPORT_QRCODE_0], [SUPPORT_QRCODE_1]
    private(set) public var mSupportQrcode: Int = 0
    /// 设备是否支持新的天气协议(支持7天)
    private(set) public var mSupportWeather2: Int = 0
    /// 是否支持支付宝
    private(set) public var mSupportAlipay: Int = 0
    /// 是否支持待机设置
    private(set) public var mSupportStandbySet: Int = 0
    /// 是否支持2D加速资源, 例如在线表盘, 自定义表盘之类的
    private(set) public var mSupport2DAcceleration: Int = 0
    /// 是否支持涂鸦授权码修改
    private(set) public var mSupportTuyaKey: Int = 0
    /// 是否支持药物提醒2简化版功能, 这个是简化版本的吃药提醒, 就类似闹钟
    private(set) public var mSupportMedicationAlarm: Int = 0
    /// 是否支持读取获取手表字库/UI/语言包/信息
    private(set) public var mSupportReadPackageStatus: Int = 0
    /// 支持的联系人数量, 如果返回0, 默认20条, 返回大于0, 则是size = value * 10
    private(set) public var mSupportContactSize: Int = 0
    /// 是否支持语音助手（小度）
    private(set) public var mSupportVoice: Int = 0
    /// 是否支持导航
    private(set) public var mSupportNavigation: Int = 0
    /// 是否支持心率警报设置
    private(set) public var mSupportHrWarnSet: Int = 0
    /// 如果有BLE名称，表示app可修改蓝牙名；不需要修改蓝牙名，直接配置为空
    private(set) public var mBleDefaultName: String?
    /// 是否支持APP音乐传输
    private(set) public var mSupportMusicTransfer: Int = 0
    /// 是否支持App勿扰时间段的设置和总开关设置
    private(set) public var mSupportNoDisturbSet2: Int = 0
    /// 仅仅提供给QCY使用, 用于判断是否支持SOS设置, 其他应用禁止使用不要使用
    private(set) public var mSupportSOSSet: Int = 0
    /// 是否支持获取语言列表
    private(set) public var mSupportReadLanguages: Int = 0
    /// 是否支持女性生理期提醒设置
    private(set) public var mSupportGirlCareReminder: Int = 0
    /// 是否支持信息提醒APP开关设置2
    private(set) public var mSupportAppPushSwitch: Int = 0
    /// 支持的收款码二维码数量
    private(set) public var mSupportReceiptCodeSize: Int = 0
    /// 是否支持游戏运动健康功能
    private(set) public var mSupportGameTimeReminder: Int = 0
    /// 支持我的名片数量
    private(set) public var mSupportMyCardCodeSize: Int = 0
    /// 是否支持实时传输运动数据改App
    private(set) public var mSupportDeviceSportData: Int = 0
    /// 是否支持电子书传输
    private(set) public var mSupportEbookTransfer: Int = 0
    /// 是否支持双击亮屏
    private(set) public var mSupportDoubleScreen: Int = 0
    /// 是否支持自定义logo
    private(set) public var mSupportCustomLogo: Int = 0
    /// 是否支持app设置压力定时测量
    private(set) public var mSupportPressureTimingMeasurement: Int = 0
    /// 是否支持定时待机表盘设置
    private(set) public var mSupportTimerStandbySet: Int = 0
    /// 是否支持SOS设置, 后续判断是否支持SOS使用这个
    private(set) public var mSupportSOSSet2: Int = 0
    /// 是否支持跌落设置, 后续判断是否支持SOS使用这个
    private(set) public var mSupportFallSet: Int = 0
    /// 是否支持骑行和步行
    private(set) public var mSupportWalkAndBike: Int = 0
    /// 是否支持连接提醒, 目前是多设备切换后连接上设备时候发出提醒
    private(set) public var mSupportConnectReminder: Int = 0
    /// 是否支持读取SDCard信息
    private(set) public var mSupportSDCardInfo: Int = 0
    /// 是否支持来电铃声设置,   0:不支持;   1支持
    private(set) public var mSupportIncomingCallRing: Int = 0
    /// 是否支持消息亮屏设置,   0:不支持;   1支持
    private(set) public var mSupportNotificationLightScreenSet: Int = 0
    /// 是否支持血压标定,   0:不支持;   1支持
    private(set) public var mSupportBloodPressureCalibration: Int = 0
    /// 是否支持传输OTA文件,   0:不支持;   1支持
    private(set) public var mSupportOTAFile: Int = 0
    /// 是否支持传输GPS 固件文件,   0:不支持;   1支持
    private(set) public var mSupportGPSFirmwareFile: Int = 0
    /// 是否支持传输GoMore算法key,   0:不支持;   1支持
    private(set) public var mSupportGoMoreSet: Int = 0
    /// 是否支持来电铃声和震动的设置,   0:不支持;   1支持
    private(set) public var mSupportRingVibrationSet: Int = 0
    /// 是否支持网络,   0:不支持;   1支持
    private(set) public var mSupportNetwork: Int = 0
    /// 是否支持联系人排序,   0:不支持;   1支持
    private(set) public var mSupportContactSort: Int = 0
    /// 二维码最大数量
    private(set) public var mQrcodeSize: Int = 0
    /// 二维码内容最大字节
    private(set) public var mQrcodeContentSize: UInt = 0
    /// 是否支持字符串二维码, 不支持就使用点阵数据
    private(set) public var mSupportStringQrcode: Int = 0
    /// 是否支持表盘索引, 表盘切换
    private(set) public var mSupportWatchFaceIndex: Int = 0
    /// 是否支持SOS紧急联系人, 最多支持5个, 这个也支持设置姓名, 之前的仅设置一个SOS的联系人电话还不能设置姓名
    private(set) public var mSupportSosContact: Int = 0
    /// 是否支持生理期月报
    private(set) public var mSupportGirlCareMonthly: Int = 0
    /// 是否支持佩戴方式, 左右手
    private(set) public var mSupportWearWay: Int = 0
    /// 是否支持翻腕亮屏2
    private(set) public var mSupportGestureWake2: Int = 0
    /// 是否支持导航图片
    private(set) public var mSupportNavImage: Int = 0
    /// 是否支持语音长度按照单包最长长度发送
    private(set) public var mSupportVoiceMaxLength: Int = 0
    
    
    required public init(_ data: Data?, _ byteOrder: ByteOrder) {
        super.init(data, byteOrder)
    }

    override func decode() {
        super.decode()
        mId = Int(readInt32())
        let dataKeyData = readDataUtil(0)
        let dataCount = dataKeyData.count / 2
        mDataKeys.removeAll()
        for i in 0..<dataCount {
            mDataKeys.append(Data(dataKeyData[i * 2..<(i + 1) * 2]).getUInt(0, 2))
        }
        mBleName = readStringUtil(0)
        mBleAddress = readStringUtil(0)
        mPlatform = readStringUtil(0)
        mPrototype = readStringUtil(0)
        mFirmwareFlag = readStringUtil(0)

        
        
        mAGpsType = Int(readInt8())
        mIOBufferSize = Int(readUInt16())
        mWatchFaceType = Int(readInt8())
        mClassicAddress = readStringUtil(0)
        mHideDigitalPower = Int(readInt8())
        mAntiLostSwitch = Int(readInt8())
        mSleepAlgorithmType = Int(readInt8())
        mDateFormat = Int(readInt8())
        mSupportReadDeviceInfo = Int(readInt8())
        mTemperatureUnit = Int(readInt8())
        mDrinkWater = Int(readInt8())
        mChangeClassicBluetoothState = Int(readInt8())
        mAppSport = Int(readInt8())
        mBloodOxyGenSet = Int(readInt8())
        mWashSet = Int(readInt8())
        mDemandWeather = Int(readInt8())
        mSupportHID = Int(readInt8())
        miBeacon = Int(readInt8())
        mSupportWatchFaceId = Int(readInt8())
        mSupportNewTransportMode = Int(readInt8())
        mSupportJLWatchFace = Int(readInt8())
        mSupportFindWatch = Int(readInt8())
        mSupportWorldClock = Int(readInt8())
        mSupportStock = Int(readInt8())
        mSupportSMSQuickReply = Int(readInt8())
        mSupportNoDisturbSet = Int(readInt8())
        mSupportSetWatchPassword = Int(readInt8())
        mSupportRealTimeMeasurement = Int(readInt8())
        mSupportPowerSaveMode = Int(readInt8())
        mSupportLoveTap = Int(readInt8())
        mSupportNewsfeed = Int(readInt8())
        mSupportMedicationReminder = Int(readInt8())
        mSupportQrcode = Int(readInt8())
        mSupportWeather2 = Int(readInt8())
        mSupportAlipay = Int(readInt8())
        mSupportStandbySet = Int(readInt8())
        mSupport2DAcceleration = Int(readInt8())
        mSupportTuyaKey = Int(readInt8())
        mSupportMedicationAlarm = Int(readInt8())
        mSupportReadPackageStatus = Int(readInt8())
        mSupportContactSize = Int(readInt8()) * 10
        mSupportVoice = Int(readInt8())
        mSupportNavigation = Int(readInt8())
        mSupportHrWarnSet = Int(readInt8())
        
        // 如果固件标记包含特殊分隔符, 说明这个设备支持自定义蓝牙名, 这个方法会废弃, 现在保留仅仅做为兼容
        if mFirmwareFlag.contains(kRAW_NAME_SEPARATOR) {
            
            if let rawName = mFirmwareFlag.components(separatedBy: kRAW_NAME_SEPARATOR).last {
                
                // rawName不为空, 并且和mBleName一致, 就是用户修改了蓝牙名, 需要重新调整显示的蓝牙名
                if rawName != mBleName {
                    mBleCustomName = mBleName  // 保存自定义名称
                    mBleName = rawName  // mBleName 始终都显示正确的蓝牙名
                }
            }
        }
        
        
        // mBleDefaultName 有数据也就代表这个设备是支持自定义蓝牙的, 后期都是用这个方式来判断是否支持自定义蓝牙名
        // 获取默认蓝牙名, 这个是代表设备的原始蓝牙名
        mBleDefaultName = readStringUtil(0)
        if let safaName = mBleDefaultName ,!safaName.isEmpty {
            mBleCustomName = mBleName    // 保存自定义的蓝牙名
            mBleName = safaName   // 强制更改为原始蓝牙名
        }
        
        
        mSupportMusicTransfer = Int(readInt8())
        mSupportNoDisturbSet2 = Int(readInt8())
        mSupportSOSSet = Int(readInt8())
        mSupportReadLanguages = Int(readInt8())
        mSupportGirlCareReminder = Int(readInt8())
        mSupportAppPushSwitch = Int(readInt8())
        mSupportReceiptCodeSize = Int(readInt8())
        mSupportGameTimeReminder = Int(readInt8())
        mSupportMyCardCodeSize = Int(readInt8())
        mSupportDeviceSportData = Int(readInt8())
        mSupportEbookTransfer = Int(readInt8())
        mSupportDoubleScreen =  Int(readInt8())
        mSupportCustomLogo = Int(readInt8())
        mSupportPressureTimingMeasurement =  Int(readInt8())
        mSupportTimerStandbySet = Int(readInt8())
        mSupportSOSSet2 = Int(readInt8())
        mSupportFallSet = Int(readInt8())
        mSupportWalkAndBike = Int(readInt8())
        mSupportConnectReminder = Int(readInt8())
        mSupportSDCardInfo = Int(readInt8())
        mSupportIncomingCallRing = Int(readInt8())
        mSupportNotificationLightScreenSet = Int(readInt8())
        mSupportBloodPressureCalibration = Int(readInt8())
        mSupportOTAFile = Int(readInt8())
        mSupportGPSFirmwareFile = Int(readInt8())
        mSupportGoMoreSet = Int(readInt8())
        mSupportRingVibrationSet = Int(readInt8())
        mSupportNetwork = Int(readInt8())
        mSupportContactSort = Int(readInt8())
        mQrcodeSize = Int(readInt8())
        mQrcodeContentSize = UInt(readUInt8())
        mSupportStringQrcode = Int(readInt8())
        mSupportWatchFaceIndex = Int(readUInt8())
        mSupportSosContact = Int(readInt8())
        mSupportGirlCareMonthly = Int(readInt8())
        mSupportWearWay = Int(readInt8())
        mSupportGestureWake2 = Int(readInt8())
        mSupportNavImage = Int(readInt8())
        mSupportVoiceMaxLength = Int(readInt8())
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mId = try container.decode(Int.self, forKey: .mId)
        mDataKeys = try container.decode([Int].self, forKey: .mDataKeys)
        mBleName = try container.decode(String.self, forKey: .mBleName)
        mBleCustomName = try container.decode(String.self, forKey: .mBleCustomName)
        mBleAddress = try container.decode(String.self, forKey: .mBleAddress)
        mPlatform = try container.decode(String.self, forKey: .mPlatform)
        mPrototype = try container.decode(String.self, forKey: .mPrototype)
        mFirmwareFlag = try container.decode(String.self, forKey: .mFirmwareFlag)
        mAGpsType = try container.decode(Int.self, forKey: .mAGpsType)
        mIOBufferSize = try container.decodeIfPresent(Int.self, forKey: .mIOBufferSize) ?? BleStreamPacket.BUFFER_MAX_SIZE
        mWatchFaceType = try container.decodeIfPresent(Int.self, forKey: .mWatchFaceType) ?? BleDeviceInfo.WATCH_FACE_NONE
        mClassicAddress = try container.decodeIfPresent(String.self, forKey: .mClassicAddress) ?? ""
        mHideDigitalPower = try container.decodeIfPresent(Int.self, forKey: .mHideDigitalPower) ?? 0
        mAntiLostSwitch = try container.decodeIfPresent(Int.self, forKey: .mAntiLostSwitch) ?? 0
        mSleepAlgorithmType = try container.decodeIfPresent(Int.self, forKey: .mSleepAlgorithmType) ?? 0
        mDateFormat = try container.decodeIfPresent(Int.self, forKey: .mDateFormat) ?? 0
        mSupportReadDeviceInfo = try container.decodeIfPresent(Int.self, forKey: .mSupportReadDeviceInfo) ?? 0
        mTemperatureUnit = try container.decodeIfPresent(Int.self, forKey: .mTemperatureUnit) ?? 0
        mDrinkWater = try container.decodeIfPresent(Int.self, forKey: .mDrinkWater) ?? 0
        mChangeClassicBluetoothState = try container.decodeIfPresent(Int.self, forKey: .mChangeClassicBluetoothState) ?? 0
        mAppSport  = try container.decodeIfPresent(Int.self, forKey: .mAppSport) ?? 0
        mBloodOxyGenSet  = try container.decodeIfPresent(Int.self, forKey: .mBloodOxyGenSet) ?? 0
        mWashSet  = try container.decodeIfPresent(Int.self, forKey: .mWashSet) ?? 0
        mDemandWeather = try container.decodeIfPresent(Int.self, forKey: .mDemandWeather) ?? 0
        mSupportHID = try container.decodeIfPresent(Int.self, forKey: .mSupportHID) ?? 0
        miBeacon = try container.decodeIfPresent(Int.self, forKey: .miBeacon) ?? 0
        mSupportWatchFaceId = try container.decodeIfPresent(Int.self, forKey: .mSupportWatchFaceId) ?? 0
        mSupportNewTransportMode = try container.decodeIfPresent(Int.self, forKey: .mSupportNewTransportMode) ?? 0
        mSupportJLWatchFace = try container.decodeIfPresent(Int.self, forKey: .mSupportJLWatchFace) ?? 0
        mSupportFindWatch = try container.decodeIfPresent(Int.self, forKey: .mSupportFindWatch) ?? 0
        mSupportWorldClock = try container.decodeIfPresent(Int.self, forKey: .mSupportWorldClock) ?? 0
        mSupportStock = try container.decodeIfPresent(Int.self, forKey: .mSupportStock) ?? 0
        mSupportSMSQuickReply = try container.decodeIfPresent(Int.self, forKey: .mSupportSMSQuickReply) ?? 0
        mSupportNoDisturbSet = try container.decodeIfPresent(Int.self, forKey: .mSupportNoDisturbSet) ?? 0
        mSupportSetWatchPassword = try container.decodeIfPresent(Int.self, forKey: .mSupportSetWatchPassword) ?? 0
        mSupportRealTimeMeasurement = try container.decodeIfPresent(Int.self, forKey: .mSupportRealTimeMeasurement) ?? 0
        mSupportPowerSaveMode = try container.decodeIfPresent(Int.self, forKey: .mSupportPowerSaveMode) ?? 0
        mSupportLoveTap = try container.decodeIfPresent(Int.self, forKey: .mSupportLoveTap) ?? 0
        mSupportNewsfeed = try container.decodeIfPresent(Int.self, forKey: .mSupportNewsfeed) ?? 0
        mSupportMedicationReminder = try container.decodeIfPresent(Int.self, forKey: .mSupportMedicationReminder) ?? 0
        mSupportQrcode = try container.decodeIfPresent(Int.self, forKey: .mSupportQrcode) ?? 0
        mSupportWeather2 = try container.decodeIfPresent(Int.self, forKey: .mSupportWeather2) ?? 0
        mSupportAlipay = try container.decodeIfPresent(Int.self, forKey: .mSupportAlipay) ?? 0
        mSupportStandbySet = try container.decodeIfPresent(Int.self, forKey: .mSupportStandbySet) ?? 0
        mSupport2DAcceleration = try container.decodeIfPresent(Int.self, forKey: .mSupport2DAcceleration) ?? 0
        mSupportTuyaKey = try container.decodeIfPresent(Int.self, forKey: .mSupportTuyaKey) ?? 0
        mSupportMedicationAlarm = try container.decodeIfPresent(Int.self, forKey: .mSupportMedicationAlarm) ?? 0
        mSupportReadPackageStatus = try container.decodeIfPresent(Int.self, forKey: .mSupportReadPackageStatus) ?? 0
        mSupportContactSize = try container.decodeIfPresent(Int.self, forKey: .mSupportContactSize) ?? 0
        mSupportVoice = try container.decodeIfPresent(Int.self, forKey: .mSupportVoice) ?? 0
        mSupportNavigation = try container.decodeIfPresent(Int.self, forKey: .mSupportNavigation) ?? 0
        mSupportHrWarnSet = try container.decodeIfPresent(Int.self, forKey: .mSupportHrWarnSet) ?? 0
        mBleDefaultName = try? container.decode(String.self, forKey: .mBleDefaultName)
        mSupportMusicTransfer = try container.decodeIfPresent(Int.self, forKey: .mSupportMusicTransfer) ?? 0
        mSupportNoDisturbSet2 = try container.decodeIfPresent(Int.self, forKey: .mSupportNoDisturbSet2) ?? 0
        mSupportSOSSet = try container.decodeIfPresent(Int.self, forKey: .mSupportSOSSet) ?? 0
        mSupportReadLanguages = try container.decodeIfPresent(Int.self, forKey: .mSupportReadLanguages) ?? 0
        mSupportGirlCareReminder = try container.decodeIfPresent(Int.self, forKey: .mSupportGirlCareReminder) ?? 0
        mSupportAppPushSwitch = try container.decodeIfPresent(Int.self, forKey: .mSupportAppPushSwitch) ?? 0
        mSupportReceiptCodeSize = try container.decodeIfPresent(Int.self, forKey: .mSupportReceiptCodeSize) ?? 0
        mSupportGameTimeReminder = try container.decodeIfPresent(Int.self, forKey: .mSupportGameTimeReminder) ?? 0
        mSupportMyCardCodeSize = try container.decodeIfPresent(Int.self, forKey: .mSupportMyCardCodeSize) ?? 0
        mSupportDeviceSportData = try container.decodeIfPresent(Int.self, forKey: .mSupportDeviceSportData) ?? 0
        mSupportEbookTransfer = try container.decodeIfPresent(Int.self, forKey: .mSupportEbookTransfer) ?? 0
        mSupportDoubleScreen = try container.decodeIfPresent(Int.self, forKey: .mSupportDoubleScreen) ?? 0
        mSupportCustomLogo = try container.decodeIfPresent(Int.self, forKey: .mSupportCustomLogo) ?? 0
        mSupportPressureTimingMeasurement = try container.decodeIfPresent(Int.self, forKey: .mSupportPressureTimingMeasurement) ?? 0
        mSupportTimerStandbySet = try container.decodeIfPresent(Int.self, forKey: .mSupportTimerStandbySet) ?? 0
        mSupportSOSSet2 = try container.decodeIfPresent(Int.self, forKey: .mSupportSOSSet2) ?? 0
        mSupportFallSet = try container.decodeIfPresent(Int.self, forKey: .mSupportFallSet) ?? 0
        mSupportWalkAndBike = try container.decodeIfPresent(Int.self, forKey: .mSupportWalkAndBike) ?? 0
        mSupportConnectReminder = try container.decodeIfPresent(Int.self, forKey: .mSupportConnectReminder) ?? 0
        mSupportSDCardInfo = try container.decodeIfPresent(Int.self, forKey: .mSupportSDCardInfo) ?? 0
        mSupportIncomingCallRing = try container.decodeIfPresent(Int.self, forKey: .mSupportIncomingCallRing) ?? 0
        mSupportNotificationLightScreenSet = try container.decodeIfPresent(Int.self, forKey: .mSupportNotificationLightScreenSet) ?? 0
        mSupportBloodPressureCalibration = try container.decodeIfPresent(Int.self, forKey: .mSupportBloodPressureCalibration) ?? 0
        mSupportOTAFile = try container.decodeIfPresent(Int.self, forKey: .mSupportOTAFile) ?? 0
        mSupportGPSFirmwareFile = try container.decodeIfPresent(Int.self, forKey: .mSupportGPSFirmwareFile) ?? 0
        mSupportGoMoreSet = try container.decodeIfPresent(Int.self, forKey: .mSupportGoMoreSet) ?? 0
        mSupportRingVibrationSet = try container.decodeIfPresent(Int.self, forKey: .mSupportRingVibrationSet) ?? 0
        mSupportNetwork = try container.decodeIfPresent(Int.self, forKey: .mSupportNetwork) ?? 0
        mSupportContactSort = try container.decodeIfPresent(Int.self, forKey: .mSupportContactSort) ?? 0
        mQrcodeSize = try container.decodeIfPresent(Int.self, forKey: .mQrcodeSize) ?? 0
        mQrcodeContentSize = try container.decodeIfPresent(UInt.self, forKey: .mQrcodeContentSize) ?? 0
        mSupportStringQrcode = try container.decodeIfPresent(Int.self, forKey: .mSupportStringQrcode) ?? 0
        mSupportWatchFaceIndex = try container.decodeIfPresent(Int.self, forKey: .mSupportWatchFaceIndex) ?? 0
        mSupportSosContact = try container.decodeIfPresent(Int.self, forKey: .mSupportSosContact) ?? 0
        mSupportGirlCareMonthly = try container.decodeIfPresent(Int.self, forKey: .mSupportGirlCareMonthly) ?? 0
        mSupportWearWay = try container.decodeIfPresent(Int.self, forKey: .mSupportWearWay) ?? 0
        mSupportGestureWake2 = try container.decodeIfPresent(Int.self, forKey: .mSupportGestureWake2) ?? 0
        mSupportNavImage = try container.decodeIfPresent(Int.self, forKey: .mSupportNavImage) ?? 0
        mSupportVoiceMaxLength = try container.decodeIfPresent(Int.self, forKey: .mSupportVoiceMaxLength) ?? 0
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mId, forKey: .mId)
        try container.encode(mDataKeys, forKey: .mDataKeys)
        try container.encode(mBleName, forKey: .mBleName)
        try container.encode(mBleCustomName, forKey: .mBleCustomName)
        try container.encode(mBleAddress, forKey: .mBleAddress)
        try container.encode(mPlatform, forKey: .mPlatform)
        try container.encode(mPrototype, forKey: .mPrototype)
        try container.encode(mFirmwareFlag, forKey: .mFirmwareFlag)
        try container.encode(mAGpsType, forKey: .mAGpsType)
        try container.encode(mIOBufferSize, forKey: .mIOBufferSize)
        try container.encode(mWatchFaceType, forKey: .mWatchFaceType)
        try container.encode(mClassicAddress, forKey: .mClassicAddress)
        try container.encode(mHideDigitalPower, forKey: .mHideDigitalPower)
        try container.encode(mAntiLostSwitch, forKey: .mAntiLostSwitch)
        try container.encode(mSleepAlgorithmType, forKey: .mSleepAlgorithmType)
        try container.encode(mDateFormat, forKey: .mDateFormat)
        try container.encode(mSupportReadDeviceInfo, forKey: .mSupportReadDeviceInfo)
        try container.encode(mTemperatureUnit, forKey: .mTemperatureUnit)
        try container.encode(mDrinkWater, forKey: .mDrinkWater)
        try container.encode(mChangeClassicBluetoothState, forKey: .mChangeClassicBluetoothState)
        try container.encode(mAppSport, forKey: .mAppSport)
        try container.encode(mBloodOxyGenSet, forKey: .mBloodOxyGenSet)
        try container.encode(mWashSet, forKey: .mWashSet)
        try container.encode(mDemandWeather, forKey: .mDemandWeather)
        try container.encode(mSupportHID, forKey: .mSupportHID)
        try container.encode(miBeacon, forKey: .miBeacon)
        try container.encode(mSupportWatchFaceId, forKey: .mSupportWatchFaceId)
        try container.encode(mSupportNewTransportMode, forKey: .mSupportNewTransportMode)
        try container.encode(mSupportJLWatchFace, forKey: .mSupportJLWatchFace)
        try container.encode(mSupportFindWatch, forKey: .mSupportFindWatch)
        try container.encode(mSupportWorldClock, forKey: .mSupportWorldClock)
        try container.encode(mSupportStock, forKey: .mSupportStock)
        try container.encode(mSupportSMSQuickReply, forKey: .mSupportSMSQuickReply)
        try container.encode(mSupportNoDisturbSet, forKey: .mSupportNoDisturbSet)
        try container.encode(mSupportSetWatchPassword, forKey: .mSupportSetWatchPassword)
        try container.encode(mSupportRealTimeMeasurement, forKey: .mSupportRealTimeMeasurement)
        try container.encode(mSupportPowerSaveMode, forKey: .mSupportPowerSaveMode)
        try container.encode(mSupportLoveTap, forKey: .mSupportLoveTap)
        try container.encode(mSupportNewsfeed, forKey: .mSupportNewsfeed)
        try container.encode(mSupportMedicationReminder, forKey: .mSupportMedicationReminder)
        try container.encode(mSupportQrcode, forKey: .mSupportQrcode)
        try container.encode(mSupportWeather2, forKey: .mSupportWeather2)
        try container.encode(mSupportAlipay, forKey: .mSupportAlipay)
        try container.encode(mSupportStandbySet, forKey: .mSupportStandbySet)
        try container.encode(mSupport2DAcceleration, forKey: .mSupport2DAcceleration)
        try container.encode(mSupportTuyaKey, forKey: .mSupportTuyaKey)
        try container.encode(mSupportMedicationAlarm, forKey: .mSupportMedicationAlarm)
        try container.encode(mSupportReadPackageStatus, forKey: .mSupportReadPackageStatus)
        try container.encode(mSupportContactSize, forKey: .mSupportContactSize)
        try container.encode(mSupportVoice, forKey: .mSupportVoice)
        try container.encode(mSupportNavigation, forKey: .mSupportNavigation)
        try container.encode(mSupportHrWarnSet, forKey: .mSupportHrWarnSet)
        try container.encode(mBleDefaultName, forKey: .mBleDefaultName)
        try container.encode(mSupportMusicTransfer, forKey: .mSupportMusicTransfer)
        try container.encode(mSupportNoDisturbSet2, forKey: .mSupportNoDisturbSet2)
        try container.encode(mSupportSOSSet, forKey: .mSupportSOSSet)
        try container.encode(mSupportReadLanguages, forKey: .mSupportReadLanguages)
        try container.encode(mSupportGirlCareReminder, forKey: .mSupportGirlCareReminder)
        try container.encode(mSupportAppPushSwitch, forKey: .mSupportAppPushSwitch)
        try container.encode(mSupportReceiptCodeSize, forKey: .mSupportReceiptCodeSize)
        try container.encode(mSupportGameTimeReminder, forKey: .mSupportGameTimeReminder)
        try container.encode(mSupportMyCardCodeSize, forKey: .mSupportMyCardCodeSize)
        try container.encode(mSupportDeviceSportData, forKey: .mSupportDeviceSportData)
        try container.encode(mSupportEbookTransfer, forKey: .mSupportEbookTransfer)
        try container.encode(mSupportDoubleScreen, forKey: .mSupportDoubleScreen)
        try container.encode(mSupportCustomLogo, forKey: .mSupportCustomLogo)
        try container.encode(mSupportPressureTimingMeasurement, forKey: .mSupportPressureTimingMeasurement)
        try container.encode(mSupportTimerStandbySet, forKey: .mSupportTimerStandbySet)
        try container.encode(mSupportSOSSet2, forKey: .mSupportSOSSet2)
        try container.encode(mSupportFallSet, forKey: .mSupportFallSet)
        try container.encode(mSupportWalkAndBike, forKey: .mSupportWalkAndBike)
        try container.encode(mSupportConnectReminder, forKey: .mSupportConnectReminder)
        try container.encode(mSupportSDCardInfo, forKey: .mSupportSDCardInfo)
        try container.encode(mSupportIncomingCallRing, forKey: .mSupportIncomingCallRing)
        try container.encode(mSupportNotificationLightScreenSet, forKey: .mSupportNotificationLightScreenSet)
        try container.encode(mSupportBloodPressureCalibration, forKey: .mSupportBloodPressureCalibration)
        try container.encode(mSupportOTAFile, forKey: .mSupportOTAFile)
        try container.encode(mSupportGPSFirmwareFile, forKey: .mSupportGPSFirmwareFile)
        try container.encode(mSupportGoMoreSet, forKey: .mSupportGoMoreSet)
        try container.encode(mSupportRingVibrationSet, forKey: .mSupportRingVibrationSet)
        try container.encode(mSupportNetwork, forKey: .mSupportNetwork)
        try container.encode(mSupportContactSort, forKey: .mSupportContactSort)
        try container.encode(mQrcodeSize, forKey: .mQrcodeSize)
        try container.encode(mQrcodeContentSize, forKey: .mQrcodeContentSize)
        try container.encode(mSupportStringQrcode, forKey: .mSupportStringQrcode)
        try container.encode(mSupportWatchFaceIndex, forKey: .mSupportWatchFaceIndex)
        try container.encode(mSupportSosContact, forKey: .mSupportSosContact)
        try container.encode(mSupportGirlCareMonthly, forKey: .mSupportGirlCareMonthly)
        try container.encode(mSupportWearWay, forKey: .mSupportWearWay)
        try container.encode(mSupportGestureWake2, forKey: .mSupportGestureWake2)
        try container.encode(mSupportNavImage, forKey: .mSupportNavImage)
        try container.encode(mSupportVoiceMaxLength, forKey: .mSupportVoiceMaxLength)
    }

    /// 为了适配旧设备, 这个方法需要再非常明确的情况下调用, 否则影响设备
    public func updateSupportNewTransportMode(_ value: Int) {
        self.mSupportNewTransportMode = value
    }
    
    private enum CodingKeys: String, CodingKey {
        case mId, mDataKeys, mBleName, mBleCustomName, mBleAddress, mPlatform, mPrototype, mFirmwareFlag, mAGpsType
        case mIOBufferSize, mWatchFaceType, mClassicAddress, mHideDigitalPower, mAntiLostSwitch
        case mSleepAlgorithmType, mDateFormat, mSupportReadDeviceInfo, mTemperatureUnit,mDrinkWater,mChangeClassicBluetoothState,mAppSport,mBloodOxyGenSet,mWashSet,mDemandWeather,mSupportHID
        case miBeacon,mSupportWatchFaceId,mSupportNewTransportMode,mSupportJLWatchFace
        case mSupportFindWatch,mSupportWorldClock,mSupportStock,mSupportSMSQuickReply,mSupportNoDisturbSet,mSupportSetWatchPassword
        case mSupportRealTimeMeasurement
        case mSupportPowerSaveMode
        case mSupportLoveTap, mSupportNewsfeed, mSupportMedicationReminder, mSupportQrcode, mSupportWeather2
        case mSupportAlipay, mSupportStandbySet, mSupport2DAcceleration, mSupportTuyaKey, mSupportMedicationAlarm
        case mSupportReadPackageStatus, mSupportContactSize, mSupportVoice, mSupportNavigation
        case mSupportHrWarnSet, mSupportMusicTransfer, mBleDefaultName
        case mSupportNoDisturbSet2, mSupportSOSSet, mSupportReadLanguages, mSupportGirlCareReminder
        case mSupportAppPushSwitch, mSupportReceiptCodeSize, mSupportGameTimeReminder, mSupportMyCardCodeSize
        case mSupportDeviceSportData, mSupportEbookTransfer, mSupportDoubleScreen, mSupportCustomLogo
        case mSupportPressureTimingMeasurement, mSupportTimerStandbySet, mSupportSOSSet2, mSupportFallSet
        case mSupportWalkAndBike, mSupportConnectReminder, mSupportSDCardInfo, mSupportIncomingCallRing
        case mSupportNotificationLightScreenSet, mSupportBloodPressureCalibration, mSupportOTAFile
        case mSupportGPSFirmwareFile, mSupportGoMoreSet, mSupportRingVibrationSet, mSupportNetwork, mSupportContactSort
        case mQrcodeSize, mQrcodeContentSize, mSupportStringQrcode, mSupportWatchFaceIndex, mSupportSosContact
        case mSupportGirlCareMonthly, mSupportWearWay, mSupportGestureWake2, mSupportNavImage
        case mSupportVoiceMaxLength
    }
    
    open override var description: String {
        "BleDeviceInfo("
        + "mId: \(String(format: "0x%08X", mId))"
        + ", mDataKeys: \(mDataKeys.map({ "\(BleKey(rawValue: $0) ?? BleKey.NONE)" }))"
        + ", mBleName:\(mBleName), mBleCustomName:\(mBleCustomName), mBleDefaultName:\(String(describing: mBleDefaultName)) mBleAddress:\(mBleAddress), " +
        "mPlatform:\(mPlatform), mPrototype:\(mPrototype), mFirmwareFlag:\(mFirmwareFlag), mAGpsType:\(mAGpsType), " +
        "mIOBufferSize:\(mIOBufferSize), mWatchFaceType:\(mWatchFaceType), mClassicAddress:\(mClassicAddress), " +
        "mHideDigitalPower:\(mHideDigitalPower), mAntiLostSwitch: \(mAntiLostSwitch), mSleepAlgorithmType:\(mSleepAlgorithmType), " +
        "mDateFormat:\(mDateFormat), mSupportReadDeviceInfo:\(mSupportReadDeviceInfo), mTemperatureUnit:\(mTemperatureUnit), " +
        "mDrinkWater:\(mDrinkWater), mChangeClassicBluetoothState:\(mChangeClassicBluetoothState), mAppSport:\(mAppSport), " +
        "mBloodOxyGenSet:\(mBloodOxyGenSet), mWashSet:\(mWashSet), mDemandWeather:\(mDemandWeather), " +
        "mSupportHID:\(mSupportHID), miBeacon:\(miBeacon), mSupportWatchFaceId:\(mSupportWatchFaceId) " +
        "mSupportNewTransportMode:\(mSupportNewTransportMode), mSupportJLWatchFace:\(mSupportJLWatchFace), " +
        "mSupportWorldClock:\(mSupportWorldClock), mSupportStock:\(mSupportStock), mSupportSMSQuickReply:\(mSupportSMSQuickReply), " +
        "mSupportNoDisturbSet:\(mSupportNoDisturbSet), mSupportSetWatchPassword:\(mSupportSetWatchPassword), " +
        "mSupportRealTimeMeasurement:\(mSupportRealTimeMeasurement), mSupportPowerSaveMode:\(mSupportPowerSaveMode), " +
        "mSupportLoveTap:\(mSupportLoveTap), mSupportNewsfeed:\(mSupportNewsfeed), mSupportMedicationReminder:\(mSupportMedicationReminder), " +
        "mSupportQrcode:\(mSupportQrcode), mSupportWeather2:\(mSupportWeather2)" + ", mSupportAlipay:\(mSupportAlipay), " +
        "mSupportStandbySet:\(mSupportStandbySet), mSupport2DAcceleration:\(mSupport2DAcceleration), mSupportTuyaKey:\(mSupportTuyaKey), " +
        "mSupportMedicationAlarm:\(mSupportMedicationAlarm), mSupportReadPackageStatus:\(mSupportReadPackageStatus), " +
        "mSupportContactSize:\(mSupportContactSize), mSupportVoice:\(mSupportVoice), mSupportNavigation:\(mSupportNavigation), " +
        "mSupportHrWarnSet:\(mSupportHrWarnSet), mSupportMusicTransfer:\(mSupportMusicTransfer), " +
        "mSupportSOSSet:\(mSupportSOSSet), mSupportReadLanguages:\(mSupportReadLanguages), " +
        "mSupportGirlCareReminder:\(mSupportGirlCareReminder), mSupportAppPushSwitch:\(mSupportAppPushSwitch), " +
        "mSupportReceiptCodeSize:\(mSupportReceiptCodeSize), mSupportGameTimeReminder:\(mSupportGameTimeReminder), " +
        "mSupportMyCardCodeSize:\(mSupportMyCardCodeSize), mSupportDeviceSportData:\(mSupportDeviceSportData), " +
        "mSupportEbookTransfer:\(mSupportEbookTransfer), mSupportDoubleScreen:\(mSupportDoubleScreen)," +
        "mSupportCustomLogo:\(mSupportCustomLogo), mSupportPressureTimingMeasurement:\(mSupportPressureTimingMeasurement)," +
        "mSupportTimerStandbySet:\(mSupportTimerStandbySet)" + "mSupportSOSSet2:\(mSupportSOSSet2), " +
        "mSupportFallSet:\(mSupportFallSet), " + "mSupportWalkAndBike:\(mSupportWalkAndBike), " +
        "mSupportConnectReminder:\(mSupportConnectReminder), " + "mSupportSDCardInfo:\(mSupportSDCardInfo), " +
        "mSupportIncomingCallRing:\(mSupportIncomingCallRing), mSupportNotificationLightScreenSet:\(mSupportNotificationLightScreenSet), " + "mSupportBloodPressureCalibration:\(mSupportBloodPressureCalibration), " +
        "mSupportOTAFile:\(mSupportOTAFile), " + "mSupportGPSFirmwareFile:\(mSupportGPSFirmwareFile), " +
        "mSupportGoMoreSet:\(mSupportGoMoreSet), mSupportRingVibrationSet:\(mSupportRingVibrationSet), " +
        "mSupportNetwork:\(mSupportNetwork), " + "mSupportContactSort:\(mSupportContactSort), " + "mQrcodeSize:\(mQrcodeSize), " +
        "mQrcodeContentSize:\(mQrcodeContentSize), mSupportStringQrcode:\(mSupportStringQrcode), " +
        "mSupportWatchFaceIndex:\(mSupportWatchFaceIndex), mSupportSosContact:\(mSupportSosContact), " +
        "mSupportGirlCareMonthly:\(mSupportGirlCareMonthly), " + "mSupportWearWay:\(mSupportWearWay), " +
        "mSupportGestureWake2:\(mSupportGestureWake2), mSupportNavImage:\(mSupportNavImage), mSupportVoiceMaxLength:\(mSupportVoiceMaxLength)" +
        ")"
    }
    
    public func toDictionary(_ status:Bool)->[String:Any]{
        
        let dic : [String : Any] = [
            "mId":mId,
            "mDataKeys":mDataKeys,
            "mBleName":mBleName,
            "mBleCustomName":mBleCustomName,
            "mBleDefaultName":mBleDefaultName ?? "",
            "mBleAddress":mBleAddress,
            "mPlatform":mPlatform,
            "mPrototype":mPrototype,
            "mFirmwareFlag":mFirmwareFlag,
            "mAGpsType":mAGpsType,
            "mIOBufferSize":mIOBufferSize,
            "mWatchFaceType":mWatchFaceType,
            "mClassicAddress":mClassicAddress,
            "mHideDigitalPower":mHideDigitalPower,
            "mShowAntiLostSwitch":mAntiLostSwitch,
            "mSleepAlgorithmType":mSleepAlgorithmType,
            "mSupportDateFormatSet":mDateFormat,
            "mSupportReadDeviceInfo":mSupportReadDeviceInfo,
            "mSupportTemperatureUnitSet":mTemperatureUnit,
            "mSupportDrinkWaterSet":mDrinkWater,
            "mSupportChangeClassicBluetoothState":mChangeClassicBluetoothState,
            "mSupportAppSport":mAppSport,
            "mSupportBloodOxyGenSet":mBloodOxyGenSet,
            "mSupportWashSet":mWashSet,
            "mSupportRequestRealtimeWeather":mDemandWeather,
            "mSupportHID":mSupportHID,
            "mSupportIBeaconSet":miBeacon,
            "mSupportWatchFaceId":mSupportWatchFaceId,
            "mSupportNewTransportMode":mSupportNewTransportMode,
            "mSupportJLTransport":mSupportJLWatchFace,
            "mSupportFindWatch":mSupportFindWatch,
            "mSupportWorldClock":mSupportWorldClock,
            "mSupportStock":mSupportStock,
            "mSupportSMSQuickReply":mSupportSMSQuickReply,
            "mSupportNoDisturbSet":mSupportNoDisturbSet,
            "mSupportSetWatchPassword":mSupportSetWatchPassword,
            "mSupportRealTimeMeasurement":mSupportRealTimeMeasurement,
            "mSupportPowerSaveMode":mSupportPowerSaveMode,
            "mSupportLoveTap":mSupportLoveTap,
            "mSupportNewsfeed":mSupportNewsfeed,
            "mSupportMedicationReminder":mSupportMedicationReminder,
            "mSupportQrcode":mSupportQrcode,
            "mSupportWeather2":mSupportWeather2,
            "mSupportAlipay":mSupportAlipay,
            "mSupportStandbySet":mSupportStandbySet,
            "mSupport2DAcceleration":mSupport2DAcceleration,
            "mSupportTuyaKey":mSupportTuyaKey,
            "mSupportMedicationAlarm":mSupportMedicationAlarm,
            "mSupportReadPackageStatus":mSupportReadPackageStatus,
            "mSupportContactSize": mSupportContactSize,
            "mSupportVoice":mSupportVoice,
            "mSupportNavigation":mSupportNavigation,
            "mSupportHrWarnSet": mSupportHrWarnSet,
            "mSupportMusicTransfer": mSupportMusicTransfer,
            "mSupportNoDisturbSet2": mSupportNoDisturbSet2,
            "mSupportSOSSet": mSupportSOSSet,
            "mSupportReadLanguages": mSupportReadLanguages,
            "mSupportGirlCareReminder": mSupportGirlCareReminder,
            "mSupportAppPushSwitch": mSupportAppPushSwitch,
            "mSupportReceiptCodeSize": mSupportReceiptCodeSize,
            "mSupportGameTimeReminder": mSupportGameTimeReminder,
            "mSupportMyCardCodeSize": mSupportMyCardCodeSize,
            "mSupportDeviceSportData": mSupportDeviceSportData,
            "mSupportEbookTransfer": mSupportEbookTransfer,
            "mSupportDoubleScreen": mSupportDoubleScreen,
            "mSupportCustomLogo":mSupportCustomLogo,
            "mSupportPressureTimingMeasurement": mSupportPressureTimingMeasurement,
            "mSupportTimerStandbySet": mSupportTimerStandbySet,
            "mSupportSOSSet2": mSupportSOSSet2,
            "mSupportFallSet": mSupportFallSet,
            "mSupportWalkAndBike": mSupportWalkAndBike,
            "mSupportConnectReminder": mSupportConnectReminder,
            "mSupportSDCardInfo": mSupportSDCardInfo,
            "mSupportIncomingCallRing": mSupportIncomingCallRing,
            "mSupportNotificationLightScreenSet": mSupportNotificationLightScreenSet,
            "mSupportBloodPressureCalibration": mSupportBloodPressureCalibration,
            "mSupportOTAFile": mSupportOTAFile,
            "mSupportGPSFirmwareFile": mSupportGPSFirmwareFile,
            "mSupportGoMoreSet": mSupportGoMoreSet,
            "mSupportRingVibrationSet": mSupportRingVibrationSet,
            "mSupportNetwork": mSupportNetwork,
            "mSupportContactSort": mSupportContactSort,
            "mQrcodeSize": mQrcodeSize,
            "mQrcodeContentSize": mQrcodeContentSize,
            "mSupportStringQrcode": mSupportStringQrcode,
            "mSupportWatchFaceIndex": mSupportWatchFaceIndex,
            "mSupportSosContact": mSupportSosContact,
            "mSupportGirlCareMonthly": mSupportGirlCareMonthly,
            "mSupportWearWay": mSupportWearWay,
            "mSupportGestureWake2": mSupportGestureWake2,
            "mSupportNavImage": mSupportVoiceMaxLength,
            "status":status
        ]
        return dic
    }
}
