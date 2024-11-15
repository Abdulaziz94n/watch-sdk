//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

let kPreviousDeviceSupportGoMoreValueKey = "kPreviousDeviceSupportGoMoreValueKey"
open class BleCache {
    
    public static let shared = BleCache()
    
    static let PREFIX = "ble_"
    static let DEVICE_IDENTIFY = "device_identify"
    private static let MTK_OTA_META = "mtk_ota_meta"

    

    private var mUserDefault = UserDefaults.standard

    // 设备信息会包含其aGps文件类型，发送aGps时需要根据类型来检索下载链接。
    private let mAGpsFileUrls = [
        BleDeviceInfo.AGPS_EPO: "http://wepodownload.mediatek.com/EPO_GR_3_1.DAT",
        BleDeviceInfo.AGPS_UBLOX: "https://alp.u-blox.com/current_1d.alp",
        BleDeviceInfo.AGPS_AGNSS: "https://api.smawatch.cn/epo/ble_epo_offline.bin",
        BleDeviceInfo.AGPS_EPO_ONLY: "https://api-oss.iot-solution.net/a-gps/file_info_3335_epo.DAT",
        BleDeviceInfo.AGPS_LTO: "https://api-oss.iot-solution.net/a-gps/file_info_7dv5_lto.brm",
        BleDeviceInfo.AGPS_6228: "https://api-oss.iot-solution.net/a-gps/f1e1G7C7J7.pgl",
    ]

    // 必须在绑定设备之后调用，否则返回的信息没有任何意义。
    public var mDeviceInfo: BleDeviceInfo? = nil

    public var mDataKeys: [Int] {
        mDeviceInfo?.mDataKeys ?? []
    }

    public var mBleName: String {
        mDeviceInfo?.mBleName ?? ""
    }

    public var mBleAddress: String {
        mDeviceInfo?.mBleAddress ?? ""
    }

    public var mPlatform: String {
        mDeviceInfo?.mPlatform ?? ""
    }

    public var mPrototype: String {
        mDeviceInfo?.mPrototype ?? ""
    }

    public var mFirmwareFlag: String {
        mDeviceInfo?.mFirmwareFlag ?? ""
    }

    public var mAGpsType: Int {
        mDeviceInfo?.mAGpsType ?? BleDeviceInfo.AGPS_NONE
    }

    var mIOBufferSize: Int {
        var size = mDeviceInfo?.mIOBufferSize
        if size == nil || size == 0 {
            size = BleStreamPacket.BUFFER_MAX_SIZE
        }
        return size!
    }

    public var mWatchFaceType: Int {
        mDeviceInfo?.mWatchFaceType ?? BleDeviceInfo.WATCH_FACE_NONE
    }

    public var mHideDigitalPower: Int {
        mDeviceInfo?.mHideDigitalPower ?? 0
    }
    
    public var mAntiLostSwitch: Int {
        mDeviceInfo?.mAntiLostSwitch ?? 0
    }
    
    public var mSleepAlgorithmType :Int{
        mDeviceInfo?.mSleepAlgorithmType ?? 0
    }
    
    public var mDateFormat: Int {
        mDeviceInfo?.mDateFormat ?? 0
    }

    public var mSupportReadDeviceInfo: Int {
        mDeviceInfo?.mSupportReadDeviceInfo ?? 0
    }
    
    public var mTemperatureUnit: Int {
        mDeviceInfo?.mTemperatureUnit ?? 0
    }
    
    /// 是否支持App、手表运动模式联动协议
    public var mAppSport: Int {
        mDeviceInfo?.mAppSport ?? 0
    }
    
    public var mDrinkWater: Int {
        mDeviceInfo?.mDrinkWater ?? 0
    }
    
    public var mBloodOxyGenSet: Int {
        mDeviceInfo?.mBloodOxyGenSet ?? 0
    }
    
    public var mWashSet: Int {
        mDeviceInfo?.mWashSet ?? 0
    }
    
    public var mDemandWeather: Int {
        mDeviceInfo?.mDemandWeather ?? 0
    }
    
    public var mSupportHID: Int{
        mDeviceInfo?.mSupportHID ?? 0
    }
    
    public var miBeacon: Int{
        mDeviceInfo?.miBeacon ?? 0
    }
    
    public var mSupportWatchFaceId: Int{
        mDeviceInfo?.mSupportWatchFaceId ?? 0
    }
    
    public var mSupportNewTransportMode: Int{
        mDeviceInfo?.mSupportNewTransportMode ?? 0
    }
    
    public var mSupportJLWatchFace: Int{
        mDeviceInfo?.mSupportJLWatchFace ?? 0
    }
    
    public var mSupportFindWatch : Int{
        mDeviceInfo?.mSupportFindWatch ?? 0
    }
    
    public var mSupportWorldClock : Int{
        mDeviceInfo?.mSupportWorldClock ?? 0
    }
    
    /// 是否支持股票
    public var mSupportStock: Bool{
        (mDeviceInfo?.mSupportStock ?? 0)  > 0
    }
    
    public var mSupportSMSQuickReply : Int{
        mDeviceInfo?.mSupportSMSQuickReply ?? 0
    }
    
    public var mSupportNoDisturbSet : Int{
        mDeviceInfo?.mSupportNoDisturbSet ?? 0
    }
    
    public var mSupportSetWatchPassword : Int{
        mDeviceInfo?.mSupportSetWatchPassword ?? 0
    }
    
    public var mSupportRealTimeMeasurement : Int{
        mDeviceInfo?.mSupportRealTimeMeasurement ?? 0
    }
    
    /// 设备是否支持是否支持省电模式功能
    public var mSupportPowerSaveMode: Int{
        mDeviceInfo?.mSupportPowerSaveMode ?? 0
    }
    
    /// 是否支持发送二维码数据到设备
    public var mSupportQrcode: Int{
        mDeviceInfo?.mSupportQrcode ?? 0
    }
    
    /// 设备是否支持新的天气协议(支持7天)
    public var mSupportWeather2: Int{
        mDeviceInfo?.mSupportWeather2 ?? 0
    }
    
    /// 是否支持支付宝
    public var mSupportAliPay: Int{
        mDeviceInfo?.mSupportAlipay ?? 0
    }
    /// 是否支持待机设置
    public var mSupportStandbySetting: Int{
        mDeviceInfo?.mSupportStandbySet ?? 0
    }
    /// 是否支持2D加速资源, 例如在线表盘, 自定义表盘之类的
    public var mSupport2DAcceleration: Int{
        mDeviceInfo?.mSupport2DAcceleration ?? 0
    }
    
    /// 是否支持药物提醒2简化版功能, 这个是简化版本的吃药提醒, 就类似闹钟
    public var mSupportMedicationAlarm: Int{
        mDeviceInfo?.mSupportMedicationAlarm ?? 0
    }
    
    /// 是否支持读取获取手表字库/UI/语言包/信息
    public var mSupportReadPackageStatus: Bool {
        (mDeviceInfo?.mSupportReadPackageStatus ?? 0)  == 1
    }
    
    /// 是否支持语音助手（小度）
    public var mSupportVoice: Bool {
        return (mDeviceInfo?.mSupportVoice ?? 0)  == 1
    }
    
    /// 是否支持导航
    public var mSupportNavigation: Bool {
        (mDeviceInfo?.mSupportNavigation ?? 0)  == 1
    }
    
    /// 是否支持心率警报设置
    public var mSupportHeartRateAlarmSetting: Bool {
        (mDeviceInfo?.mSupportHrWarnSet ?? 0)  == 1
    }
    
    /// 是否支持APP音乐传输
    public var mSupportMusicTransfer: Bool {
        (mDeviceInfo?.mSupportMusicTransfer ?? 0)  == 1
    }
    
    /// 是否支持App勿扰时间段的设置和总开关设置
    public var mSupportNoDisturbSet2: Bool {
        (mDeviceInfo?.mSupportNoDisturbSet2 ?? 0)  == 1
    }
    
    /// 是否支持SOS设置, 注意这个仅仅提供给QCY使用, 其他项目禁止使用
    public var mSupportSOSSet: Bool {
        (mDeviceInfo?.mSupportSOSSet ?? 0)  == 1
    }
    
    /// 是否支持获取语言列表
    public var mSupportReadLanguages: Bool {
        (mDeviceInfo?.mSupportReadLanguages ?? 0)  == 1
    }

    /// 是否支持女性生理期提醒设置
    public var mSupportGirlCareReminder: Bool {
        (mDeviceInfo?.mSupportGirlCareReminder ?? 0)  == 1
    }
    /// 是否支持信息提醒APP开关设置2
    public var mSupportAppPushSwitch: Bool {
        (mDeviceInfo?.mSupportAppPushSwitch ?? 0)  == 1
    }
    /// 支持的收款码二维码数量, 返回0, 代表不支持
    public var mSupportReceiptCodeSize: Int {
        return mDeviceInfo?.mSupportReceiptCodeSize ?? 0
    }
    /// 是否支持游戏运动健康功能
    public var mSupportGameTimeReminder: Bool {
        (mDeviceInfo?.mSupportGameTimeReminder ?? 0)  == 1
    }
    /// 支持我的名片数量, 返回0, 代表不支持
    public var mSupportMyCardCodeSize: Int {
        return mDeviceInfo?.mSupportMyCardCodeSize ?? 0
    }
    
    /// 是否支持实时传输运动数据改App
    public var mSupportDeviceSportData: Int {
        return mDeviceInfo?.mSupportDeviceSportData ?? 0
    }
    
    /// 是否支持电子书传输
    public var mSupportEbookTransfer: Int {
        return mDeviceInfo?.mSupportEbookTransfer ?? 0
    }
    
    /// 是否支持双击亮屏
    public var mSupportDoubleScreen: Int {
        return mDeviceInfo?.mSupportDoubleScreen ?? 0
    }
    
    /// 是否支持自定义logo
    public var mSupportCustomLogo: Int {
        return mDeviceInfo?.mSupportCustomLogo ?? 0
    }
    
    /// 是否支持app设置压力定时测量
    public var mSupportPressureTimingMeasurement: Bool {
        return (mDeviceInfo?.mSupportPressureTimingMeasurement ?? 0) != 0
    }
    
    /// 是否支持定时待机表盘设置
    public var mSupportTimerStandbySet: Bool {
        return (mDeviceInfo?.mSupportTimerStandbySet ?? 0) != 0
    }
    
    /// 是否支持SOS设置
    public var mSupportSOSSet2: Bool {
        (mDeviceInfo?.mSupportSOSSet2 ?? 0) != 0
    }
    
    /// 是否支持跌落设置, 后续判断是否支持SOS使用这个
    public var mSupportFallSet: Bool {
        (mDeviceInfo?.mSupportFallSet ?? 0) != 0
    }
    
    /// 是否支持骑行和步行
    public var mSupportWalkAndBike: Bool {
        (mDeviceInfo?.mSupportWalkAndBike ?? 0) != 0
    }
    
    /// 是否支持连接提醒, 目前是多设备切换后连接上设备时候发出提醒
    public var mSupportConnectReminder: Bool {
        (mDeviceInfo?.mSupportConnectReminder ?? 0) != 0
    }
    
    /// 是否支持读取SDCard信息
    public var mSupportSDCardInfo: Bool {
        (mDeviceInfo?.mSupportSDCardInfo ?? 0) != 0
    }
    
    /// 是否支持来电铃声设置
    public var mSupportIncomingCallRing: Bool {
        (mDeviceInfo?.mSupportIncomingCallRing ?? 0) != 0
    }
    
    /// 是否支持消息亮屏设置,   0:不支持;   1支持
    public var mSupportNotificationLightScreenSet: Bool {
        (mDeviceInfo?.mSupportNotificationLightScreenSet ?? 0) != 0
    }
    
    /// 是否支持血压标定,   0:不支持;   1支持
    public var mSupportBloodPressureCalibration: Bool {
        (mDeviceInfo?.mSupportBloodPressureCalibration ?? 0) != 0
    }
    
    /// 是否支持传输OTA文件,   0:不支持;   1支持
    public var mSupportOTAFile: Bool {
        (mDeviceInfo?.mSupportOTAFile ?? 0) != 0
    }
    
    /// 是否支持传输GPS 固件文件,   0:不支持;   1支持
    public var mSupportGPSFirmwareFile: Bool {
        (mDeviceInfo?.mSupportGPSFirmwareFile ?? 0) != 0
    }
    
    /// 是否支持传输GoMore算法key,   0:不支持;   1支持
    public func mSupportGoMoreSet() -> Bool {
        if BleConnector.shared.isBound() {
            return (mDeviceInfo?.mSupportGoMoreSet ?? 0) > 0
        } else {
            
            // 如果没绑定设备, 就从缓存里面取出一下上个绑定过的设备是否支持GoMore
            let str = UserDefaults.standard.string(forKey: kPreviousDeviceSupportGoMoreValueKey) ?? ""
            if str.isEmpty || str == "0" {
                return false
            } else {
                return true
            }
        }
    }
    
    /// 是否支持来电铃声和震动的设置,   0:不支持;   1支持
    public var mSupportRingVibrationSet: Bool {
        (mDeviceInfo?.mSupportRingVibrationSet ?? 0) != 0
    }
    
    /// 是否支持网络,   0:不支持;   1支持
    public var mSupportNetwork: Bool {
        (mDeviceInfo?.mSupportNetwork ?? 0) != 0
    }
    
    /// 是否支持联系人排序
    public var mSupportContactSort: Bool {
        (mDeviceInfo?.mSupportContactSort ?? 0) != 0
    }
    
    /// 二维码最大数量
    public var mQrcodeSize: Int {
        mDeviceInfo?.mQrcodeSize ?? 0
    }
    
    /// 二维码内容最大字节
    public var mQrcodeContentSize: UInt {
        mDeviceInfo?.mQrcodeContentSize ?? 0
    }
    
    /// 是否支持字符串二维码, 不支持就使用点阵数据
    public var mSupportStringQrcode: Int {
        mDeviceInfo?.mSupportStringQrcode ?? 0
    }
    
    /// 是否支持表盘索引, 表盘切换
    public var mSupportWatchFaceIndex: Bool {
        (mDeviceInfo?.mSupportWatchFaceIndex ?? 0) != 0
    }
    
    /// 是否支持SOS紧急联系人, 最多支持5个, 这个也支持设置姓名, 之前的仅设置一个SOS的联系人电话还不能设置姓名
    public var mSupportSosContact: Bool {
        (mDeviceInfo?.mSupportSosContact ?? 0) != 0
    }
    
    /// 是否支持生理期月报
    public var mSupportGirlCareMonthly: Bool {
        (mDeviceInfo?.mSupportGirlCareMonthly ?? 0) != 0
    }
    
    /// 是否支持佩戴方式, 左右手
    public var mSupportWearWay: Bool {
        (mDeviceInfo?.mSupportWearWay ?? 0) != 0
    }
    
    /// 是否支持翻腕亮屏2
    public var mSupportGestureWake2: Bool {
        (mDeviceInfo?.mSupportGestureWake2 ?? 0) != 0
    }
    
    /// 是否支持语音长度按照单包最长长度发送
    public var mSupportVoiceMaxLength: Bool {
        (mDeviceInfo?.mSupportVoiceMaxLength ?? 0) != 0
    }
    
    public var mAGpsFileUrl: String {
        mAGpsFileUrls[mAGpsType] ?? ""
    }

    public var mNotificationBundleIds: [String] {
        var bundleIds = BleNotificationSettings.ORIGIN_BUNDLE_IDS
        bundleIds.append(BleNotificationSettings.Messenger)
        bundleIds.append(BleNotificationSettings.TELEGRAM)
        bundleIds.append(BleNotificationSettings.BETWEEN)
        bundleIds.append(BleNotificationSettings.NAVERCAFE)
        bundleIds.append(BleNotificationSettings.YOUTUBE)
        bundleIds.append(BleNotificationSettings.NETFLIX)
        // 2023-02-20 新增
        //bundleIds.append(BleNotificationSettings.Tik_Tok)  // 注意这个是国外版本的抖音, 不要搞错了
        bundleIds.append(BleNotificationSettings.SNAPCHAT)
        //bundleIds.append(BleNotificationSettings.AMAZON)
        //bundleIds.append(BleNotificationSettings.UBER)
        //bundleIds.append(BleNotificationSettings.LYFT)
        //bundleIds.append(BleNotificationSettings.GOOGLE_MAPS)
        
        switch mPrototype {
        default:
            return bundleIds
        }
    }
    
    public var mNotificationBundleIds2: [String] {
        var bundleIds = BleNotificationSettings2.ORIGIN_BUNDLE_IDS
        bundleIds.append(BleNotificationSettings.Messenger)
        bundleIds.append(BleNotificationSettings.TELEGRAM)
        bundleIds.append(BleNotificationSettings.BETWEEN)
        bundleIds.append(BleNotificationSettings.NAVERCAFE)
        bundleIds.append(BleNotificationSettings.YOUTUBE)
        bundleIds.append(BleNotificationSettings.NETFLIX)
        // 2023-02-20 新增
        bundleIds.append(BlePushAppType.Tik_Tok.rawValue)  // 注意这个是国外版本的抖音, 不要搞错了
        bundleIds.append(BlePushAppType.SNAPCHAT.rawValue)
        bundleIds.append(BlePushAppType.AMAZON.rawValue)
        bundleIds.append(BlePushAppType.UBER.rawValue)
        bundleIds.append(BlePushAppType.LYFT.rawValue)
        bundleIds.append(BlePushAppType.GOOGLE_MAPS.rawValue)
        bundleIds.append(BlePushAppType.SLACK.rawValue)
        bundleIds.append(BlePushAppType.Discord.rawValue)
        // 2023-08-04 新增, 主要针对于黑鲨定制
        bundleIds.append(BlePushAppType.TumBlr.rawValue)
        bundleIds.append(BlePushAppType.Pinterest.rawValue)
        bundleIds.append(BlePushAppType.Zalo.rawValue)
        bundleIds.append(BlePushAppType.IMO.rawValue)
        bundleIds.append(BlePushAppType.VKontakte.rawValue)
        // 2023-08-04 新增, 主要针对于COA 之前的K Fit
        bundleIds.append(BlePushAppType.TikTok_KOR.rawValue) // 韩国版TikTok
        bundleIds.append(BlePushAppType.Naver_Band.rawValue)
        bundleIds.append(BlePushAppType.NAVER_APP.rawValue)
        bundleIds.append(BlePushAppType.Naver_Cafe.rawValue) // 特殊名称 Naver Café
        bundleIds.append(BlePushAppType.Signal.rawValue)
        bundleIds.append(BlePushAppType.Nate_On.rawValue)
        bundleIds.append(BlePushAppType.Daangn_Market.rawValue)
        bundleIds.append(BlePushAppType.Kiwoom_Securities.rawValue)
        bundleIds.append(BlePushAppType.Daum_Cafe.rawValue)
        bundleIds.append(BlePushAppType.Vieber_Push.rawValue)

        //20240524 添加美团钉钉
        bundleIds.append(BlePushAppType.Meituan_Push.rawValue)
        bundleIds.append(BlePushAppType.Dingding_Push.rawValue)
        return bundleIds
    }

    private init() {

    }

    /**
     * 保存绑定设备的identify。
     */
    public func putDeviceIdentify(_ identify: String?) {
        bleLog("BleCache putDeviceIdentify -> \(identify ?? "")")
        if identify == nil {
            mUserDefault.removeObject(forKey: getKey(BleCache.DEVICE_IDENTIFY))
        } else {
            mUserDefault.set(identify, forKey: getKey(BleCache.DEVICE_IDENTIFY))
        }
        mUserDefault.synchronize()
    }

    /**
     * 获取绑定设备的identify。
     */
    public func getDeviceIdentify() -> String? {
        mUserDefault.string(forKey: getKey(BleCache.DEVICE_IDENTIFY))
    }

    /**
     * 存入Bool。
     */
    func putBool(_ bleKey: BleKey, _ value: Bool, _ keyFlag: BleKeyFlag? = nil) {
        bleLog("BleCache putBool -> \(getKey(bleKey, keyFlag)), \(value)")
        mUserDefault.set(value, forKey: getKey(bleKey, keyFlag))
    }

    /**
     * 取出Bool。
     */
    public func getBool(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> Bool {
        let value = mUserDefault.bool(forKey: getKey(bleKey, keyFlag))
        bleLog("BleCache getBool -> \(getKey(bleKey, keyFlag)), \(value)")
        return value
    }

    /**
     * 存入Int。
     */
    public func putInt(_ bleKey: BleKey, _ value: Int, _ keyFlag: BleKeyFlag? = nil) {
        bleLog("BleCache putInt -> \(getKey(bleKey, keyFlag)), \(value)")
        mUserDefault.set(value, forKey: getKey(bleKey, keyFlag))
    }

    /**
     * 取出Int。
     */
    public func getInt(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> Int {
        let value = mUserDefault.integer(forKey: getKey(bleKey, keyFlag))
        bleLog("BleCache getInt -> \(getKey(bleKey, keyFlag)), \(value)")
        return value
    }

    /**
     * 存入字符串。
     */
    func putString(_ bleKey: BleKey, _ value: String, _ keyFlag: BleKeyFlag? = nil) {
        bleLog("BleCache putString -> \(getKey(bleKey, keyFlag)), \(value)")
        mUserDefault.set(value, forKey: getKey(bleKey, keyFlag))
    }

    /**
    * 取出字符串。
    */
    public func getString(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> String {
        let value = mUserDefault.string(forKey: getKey(bleKey, keyFlag)) ?? ""
        bleLog("BleCache getString -> \(getKey(bleKey, keyFlag)), \(value)")
        return value
    }

    /**
     * 存入对象。
     */
    public func putObject<T: Encodable>(_ bleKey: BleKey, _ object: T?, _ keyFlag: BleKeyFlag? = nil) {
        do {
            if object == nil {
                bleLog("BleCache putObject -> \(getKey(bleKey, keyFlag)), nil")
                mUserDefault.set(nil, forKey: getKey(bleKey, keyFlag))
            } else {
                let data = try JSONEncoder().encode(object)
                bleLog("BleCache putObject -> \(getKey(bleKey, keyFlag)), object:\(String(describing: object))"
                    + ", data:\(String(data: data, encoding: .utf8) ?? "")")
                mUserDefault.set(data, forKey: getKey(bleKey, keyFlag))
            }
        } catch {
            bleLog("-------putObject, error:\(error)")
        }
    }

    /**
     * 取出对象，可能为nil。
     */
    public func getObject<T: Decodable>(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> T? {
        do {
            if let data = mUserDefault.data(forKey: getKey(bleKey, keyFlag)) {
                
                bleLog("-------getObject START----------")
                bleLog("BleCache getObject -> getKey:\(getKey(bleKey, keyFlag))")
                bleLog("flagA01, data:\(String(data: data, encoding: .utf8) ?? "")")
                
                
                let t: T = try JSONDecoder().decode(T.self, from: data)
                bleLog("flagA02, type:\(t)")
                bleLog("-------getObject END-------------")
                
                return t
            } else {
                bleLog("BleCache getObject -> data(forKey == nil)")
            }
        } catch {
            bleLog("-------getObject error START------")
            bleLog("flagB01, error:\(error)")
            bleLog("flagB02, type:\(T.self)")
            bleLog("flagB03, bleKey:\(bleKey), raw:\(bleKey.rawValue)")
            bleLog("flagB04, keyFlag:\(String(describing: keyFlag)), raw:\(String(describing: keyFlag?.rawValue))")
            bleLog("-------getObject error END--------")
        }
        return nil
    }
    
    
    /**
     * 存入对象。
     */
    func putObject<T: Encodable>(_ key: String, _ object: T?) {
        do {
            if object == nil {
                bleLog("BleCache putObject -> key:\(key), object:nil")
                mUserDefault.set(nil, forKey: key)
            } else {
                let data = try JSONEncoder().encode(object)
                bleLog("BleCache putObject -> key:\(key), object:\(String(describing: object))"
                    + ", data:\(String(data: data, encoding: .utf8) ?? "")")
                mUserDefault.set(data, forKey: key)
            }
        } catch {

        }
    }

    /**
     * 取出对象，可能为nil。
     */
    public func getObject<T: Decodable>(_ key: String) -> T? {
        do {
            if let data = mUserDefault.data(forKey: key) {
                let t: T = try JSONDecoder().decode(T.self, from: data)
                bleLog("BleCache getObject -> key:\(key), " + "\(String(data: data, encoding: .utf8) ?? ""), \(t)")
                return t
            }
        } catch {
            bleLog("key:\(key) error:\(error)")
        }
        return nil
    }

    /**
     * 取出对象，不为nil。
     */
    public func getObjectNotNil<T: BleReadable>(_ bleKey: BleKey, _ t: T? = nil, _ keyFlag: BleKeyFlag? = nil) -> T {
        (getObject(bleKey, keyFlag) ?? t) ?? T.init()
    }

    /**
     * 存入数组。
     */
    public func putArray<T: Encodable>(_ bleKey: BleKey, _ array: [T]?, _ keyFlag: BleKeyFlag? = nil) {
        putObject(bleKey, array, keyFlag)
    }

    /**
     * 取出数组。
     */
    public func getArray<T: Decodable>(_ bleKey: BleKey, keyFlag: BleKeyFlag? = nil) -> [T] {
        getObject(bleKey, keyFlag) ?? [T]()
    }
    
    /**
     * 存入Data
     */
    public func putData(_ bleKey: BleKey, _ data: Data?, _ keyFlag: BleKeyFlag? = nil) {
        mUserDefault.set(data, forKey: getKey(bleKey, keyFlag))
    }
    
    /**
     * 取出Data
     */
    public func getData(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> Data? {
        return mUserDefault.value(forKey: getKey(bleKey, keyFlag)) as? Data
    }

    /**
     * 保存MTK设备的固件信息。
     * mid=xx;mod=xx;oem=xx;pf=xx;p_id=xx;p_sec=xx;ver=xx;d_ty=xx;
     */
    func putMtkOtaMeta(meta: String) {
        bleLog("BleCache putMtkOtaMeta -> \(meta)")
        mUserDefault.set(meta, forKey: BleCache.MTK_OTA_META)
    }

    /**
     * 获取MTK设备的固件信息。
     * mid=xx;mod=xx;oem=xx;pf=xx;p_id=xx;p_sec=xx;ver=xx;d_ty=xx;
     */
    public func getMtkOtaMeta() -> String {
        let value = mUserDefault.string(forKey: BleCache.MTK_OTA_META) ?? ""
        bleLog("BleCache getMtkOtaMeta -> \(value)")
        return value
    }

    /**
     * 移除一个指令的缓存。
     */
    public func remove(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) {
        mUserDefault.removeObject(forKey: getKey(bleKey, keyFlag))
    }

//    func getArray<T: BleReadable>(_ bleKey: BleKey, _ itemLength: Int) -> [T] {
//        var array: [T] = []
//        if let data = mUserDefault.data(forKey: getKey(bleKey.mDisplayName)) {
//            array.append(contentsOf: BleReadable.ofArray(data, itemLength) as [T])
//        }
//        bleLog("BleCache getArray -> \(bleKey.mDisplayName), \(array)")
//        return array
//    }

    /**
     * 判定一个指令是否需要缓存，只在手机端发送时判定。设备回复和主动发送指令时，不依赖该方法的返回值，如果有需要，会直接缓存。
     */
    func requireCache(_ bleKey: BleKey, _ bleKeyFlag: BleKeyFlag) -> Bool {
        switch bleKey.mBleCommand {
        case .SET:
            return bleKeyFlag == .CREATE || bleKeyFlag == .DELETE || bleKeyFlag == .UPDATE || bleKeyFlag == .RESET
        case .PUSH:
            return (bleKey == .SCHEDULE && (bleKeyFlag == .CREATE || bleKeyFlag == .DELETE || bleKeyFlag == .UPDATE))
            || (bleKey == .WEATHER_REALTIME && bleKeyFlag == .UPDATE)
            || (bleKey == .WEATHER_FORECAST && bleKeyFlag == .UPDATE)
            || (bleKey == .WEATHER_REALTIME2 && bleKeyFlag == .UPDATE)
            || (bleKey == .WEATHER_FORECAST2 && bleKeyFlag == .UPDATE)
            || (bleKey == .WORLD_CLOCK && (bleKeyFlag == .CREATE || bleKeyFlag == .DELETE))
            || (bleKey == .STOCK && (bleKeyFlag == .CREATE || bleKeyFlag == .DELETE))
        case .CONTROL:
            return bleKey == .DOUBLE_SCREEN || bleKey == .INCOMING_CALL_RING
        default:
            return false
        }
    }

    /**
     * 获取某些指令的BleIdObject数组。
     */
    func getIdObjects(_ bleKey: BleKey) -> [BleIdObject] {
        if bleKey == .ALARM {
            let alarms: [BleAlarm] = getArray(bleKey)
            return alarms
        } else if bleKey == .SCHEDULE {
            let schedules: [BleSchedule] = getArray(bleKey)
            return schedules
        } else if bleKey == .COACHING {
            let coachings: [BleCoaching] = getArray(bleKey)
            return coachings
        }else if bleKey == .WORLD_CLOCK {
            let worldClock: [BleWorldClock] = getArray(bleKey)
            return worldClock
        }else if bleKey == .STOCK {
            let mStock: [BleStock] = getArray(bleKey)
            return mStock
        }else if bleKey == .LOVE_TAP_USER {
            let mStock: [BleLoveTapUser] = getArray(bleKey)
            return mStock
        }
        return []
    }

    private func getKey(_ key: String) -> String {
        BleCache.PREFIX + key
    }

    /**
     * 根据BleKey和BleKeyFlag生成一个用于缓存的key。
     */
    private func getKey(_ bleKey: BleKey, _ keyFlag: BleKeyFlag? = nil) -> String {
        if keyFlag == nil {
            return getKey(bleKey.mDisplayName)
        } else {
            return getKey("\(bleKey.mDisplayName)_\(keyFlag!.mDisplayName)")
        }
    }

    /**
     * 清除所有缓存。
     */
    public func clear() {
        for (key, _) in mUserDefault.dictionaryRepresentation() {
            if key.starts(with: BleCache.PREFIX) {
                mUserDefault.removeObject(forKey: key)
            }
        }
        mUserDefault.synchronize()
    }
}
