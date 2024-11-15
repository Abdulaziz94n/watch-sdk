//
//  BleConnectorMethodChannel.swift
//  coding_dev_flutter_sdk
//
//  Created by SMA-IOS on 2022/6/9.
//

import UIKit
import CoreBluetooth
import Flutter
import UserNotifications

public class BleConnectorMethodChannel: NSObject, FlutterPlugin {
    
    let mBleConnector = BleConnector.shared
    let mBleCache: BleCache = BleCache.shared
    var flutterResult:FlutterResult?
    //OTA
    let ROTA = RealtekOTA.sharedInstance()
    var isRealteOTA = false
    var isReadyROTA :Bool = false //wait for the Bluetooth connection to complete
    var refreshUI : Bool = false  //mark upgrade file type
    let ROTA2 = RealtekOTABridging.instance
    
    // JL OTA功能
    var jlOTA: JLFirmwareOTA?
    private var mAssist = JL_Assist()
    
    // 判断是否开启LoveTap 测试推送功能
    var isLoveTapTest = false
    /// 自定义表盘
    private let customWatchFaceViewModel = CustomWatchFaceViewModel()
    
    
    public override init() {
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let codec = FlutterJSONMethodCodec.sharedInstance()
        let channel = FlutterMethodChannel(name: _channelPrefix+"/ble_connector", binaryMessenger: registrar.messenger(), codec: codec)
        bleConnectorResult = channel
        let instance = BleConnectorMethodChannel()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

  
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result
        let args = call.arguments as? Dictionary<String, Any?> ?? [:]
        bleLog("BleConnectorMethodChannel - \( call.method)")
        //BleConnector
        if call.method.elementsEqual(initBleConnector){
            // Initialize the Bluetooth connection. If it is not bound, do not execute the customized connection method
            initmBleConnector()
            
            // 提示用户, 是否允许弹出框
            //请求通知权限
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    print("用户不允许消息通知。")
                }
            }
            
            ABHBackgroundMonitoring.share.startListening()
        }else if call.method.elementsEqual(sendData){
           //sendData
            result(self.sendBleKey(0,args as [String : Any]))
        }else if call.method.elementsEqual(sendBoolean){
           _ = self.sendBleKey(1,args as [String : Any])
        }else if call.method.elementsEqual(SdkMethod.sendInt8.rawValue){
            //sendInt8
            result(self.sendBleKey(2,args as [String : Any]))
        }else if call.method.elementsEqual(SdkMethod.sendInt16.rawValue){
            //sendInt16  这个方法是新增加的, 需要单独处理
            result(self.sendBleKey(SdkMethod.sendInt16, args))
        }else if call.method.elementsEqual(SdkMethod.sendInt32.rawValue){
            //sendInt32
            result(self.sendBleKey(3,args as [String : Any]))
        }else if call.method.elementsEqual(sendObject){
            //sendObject
            result(self.sendBleKey(4,args as [String : Any]))
        }else if call.method.elementsEqual(sendStream){
            //sendStream
            _ = self.sendBleKey(5,args as [String : Any])
        }else if call.method.elementsEqual(connectClassic){
            //connectClassic
            bleLog("Please go to settings to connect 3.0 bluetooth")
        }else if call.method.elementsEqual(SdkMethod.launch.rawValue){
            
            //launch
            bleLog("mBleConnector.launch()")
            mBleConnector.launch()
        }else if call.method.elementsEqual(unbind){
            unPair()
        }else if call.method.elementsEqual(isBound){
            let dic : [String:Any] = [call.method:BleConnector.shared.isBound()]
            result(dic)
        }else if call.method.elementsEqual(isAvailable){
            let dic : [String:Any] = [call.method:BleConnector.shared.isAvailable()]
            result(dic)
        }else if call.method.elementsEqual(SdkMethod.setAddress.rawValue){
            
            // 设置UUID, 或者 mac地址, 需要区分
            let deviceInfo = args["address"] as? String ?? ""
            
            
            // 根据传递的参数, 判断是UUID, 还是 mac,
            // 我们公司mac是这样的 "D7:D7:29:5C:BE:5F", 包含 ":", 长度17位
            var connecType = BleConnectorType.systemUUID
            if deviceInfo.count <= 17 && deviceInfo.contains(":") {
                connecType = .macAddress
            }
            
            self.setTargetDeviceUUID(deviceInfo, connecType)
        }else if call.method.elementsEqual(connect){
            let deviceConnect = args["connect"] as? Bool ?? false
            self.connectDevice(deviceConnect)
        }else if call.method.elementsEqual(closeConnection){
            let stopReconnecting = args["stopReconnecting"] as? Bool ?? false
            self.mBleConnectorCloseDeviceConnection(stopReconnecting)
        }else if call.method.elementsEqual(SdkMethod.startOTA.rawValue){
            
            bleLog("startOTA -> args:\(args)")
            guard let filePath = args["filePath"] as? String else {
                bleLog("OTA file is nil, and the operation is not being performed")
                let error = NSError(domain: "OTA file is nil, and the operation is not being performed", code: -1002).description
                self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_PREPARE.rawValue, "progress":0, "error":error])
                return
            }

            // 判断是否存在mainServiceUUID
            guard let mainServiceUUID = args["mainServiceUUID"] as? String, !mainServiceUUID.isEmpty else {
                bleLog("Error mainServiceUUID uuid is nil")
                let error = NSError(domain: "OTA mainServiceUUID is nil", code: -1003).description
                self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":error])
                return
            }
            
            // 判断是否存在 platform
            guard let platform = args["platform"] as? String, !platform.isEmpty else {
                bleLog("Error OTA platform is nil")
                let error = NSError(domain: "OTA platform is nil", code: -1005).description
                self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":error])
                return
            }
            
            
            var uuid = ""
            var address = ""
            // 判断 isDfu
            let isDfu = args["isDfu"] as? Bool ?? false
            if isDfu {
                // 判断是否存在mac
                guard let argsAddress = args["address"] as? String, !argsAddress.isEmpty else {
                    bleLog("Error OTA uuid is nil")
                    let error = NSError(domain: "OTA isDfu == \(isDfu), address is nil", code: -1004).description
                    self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":error])
                    return
                }
                
                address = argsAddress
            } else {
                
                //let uuid = "DB897CEE-A809-A1A9-E519-6FC53A8225E1"  // 客户的设备
                //let uuid = "4D0887FE-F317-E572-A239-DD43043A3368"  // 我们的设备
                //let uuid = self.mBleConnector.mPeripheral?.identifier.uuidString ?? ""
                // 判断是否存在UUID
                guard let argsUUID = args["uuid"] as? String, !argsUUID.isEmpty else {
                    bleLog("Error OTA uuid is nil")
                    let error = NSError(domain: "OTA uuid is nil", code: -1004).description
                    self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":error])
                    return
                }
                
                uuid = argsUUID
            }
            
#warning("这里需要根据不同平台, 处理不同的逻辑")
            if platform == BleDeviceInfo.PLATFORM_JL {
                self.startJL_OTA(filePath: filePath, mainServiceUUID: mainServiceUUID, uuid: uuid, isDfu: isDfu, address: address)
            } else if platform == BleDeviceInfo.PLATFORM_REALTEK {
                self.startOTA(filePath: filePath, mainServiceUUID: mainServiceUUID, uuid: uuid)
            }
            
        }else if call.method.elementsEqual(SdkMethod.iBeaconListening.rawValue){
            
            let isOpen = args["value"] as? Bool ?? false
            bleLog("iBeaconListening value:\(isOpen)")
            
            
            if isOpen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    ABHBackgroundMonitoring.share.stopListening("CodingV0.1000000")
                    ABHBackgroundMonitoring.share.startListening()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    ABHBackgroundMonitoring.share.stopListening("CodingV0.1000000")
                }
            }
        }else if call.method.elementsEqual(SdkMethod.killApp.rawValue){
            
            // 这个仅仅是测试, 用于测试 iBeacon 杀死App, 看是否可以激活App
            /**
             下面这个代码是为了测试iBeacon激活App的时候, 我们使用代码将程序杀死, 这样才可以通过iBeacon激活, 如果用户手动杀死App, 是无法激活的
             The following code is to test that when iBeacon activates the App, we use the code to kill the program so that it can be activated through iBeacon. If the user manually kills the App, it cannot be activated
             */
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Killing app")
                // CRASH
                if ([0][1] == 1){
                    exit(0)
                }
                exit(1)
            }
        } else if call.method.elementsEqual(SdkMethod.isOpenLoveTapPush.rawValue){
            
            let sendValue = args["value"] as? Bool ?? false
            self.isLoveTapTest = sendValue
        } else if call.method == SdkMethod.onRetrieveConnectedDeviceUUID.rawValue {
            
            let uuidString = BleConnector.shared.mPeripheral?.identifier.uuidString
            result(["uuidString": uuidString])
        } else if call.method == SdkMethod.setDataKeyAutoDelete.rawValue {
            let sendValue = args["isAutoDelete"] as? Bool ?? true
            BleConnector.shared.isDeletionRecords = sendValue
        }

    }

}

extension BleConnectorMethodChannel{
    func initmBleConnector(){
        
        mBleConnector.addBleHandleDelegate(String(obj: self), self)
        //If it is not bound, do not execute the customized connection method
        if mBleConnector.isBound(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                BleConnector.shared.launch()
                BleConnector.shared.connect(true)
            }
        } else {
            bleLog("iOS, No device is bound and automatic connection is not performed")
        }
    }
    
    func sendBleKey(_ sdkMethod: SdkMethod, _ dic:[String:Any?]) -> Bool{
        let key = dic["bleKey"] as? Int ?? 0
        let flag = dic["bleKeyFlag"] as? Int ?? 0
        let bleKey : BleKey = BleKey(rawValue: key) ?? .NONE
        let bleKeyFlag : BleKeyFlag = BleKeyFlag(rawValue: flag) ?? .NONE
        bleLog("sendBleKey new - \(bleKey) \(bleKeyFlag) ")
        
        if mBleConnector.isAvailable() == false{
            bleLog("device disconnect")
        }
        
        if bleKey == .NONE && bleKeyFlag == .NONE{
            return false
        }
        
        var resultBool = false
        
        switch sdkMethod {
        case SdkMethod.sendInt16:
            let sendValue = dic["value"] as? Int ?? 0
            resultBool = mBleConnector.sendInt16(bleKey, bleKeyFlag,sendValue)
        default:
            break
        }
        
        return resultBool
    }
    
    func sendBleKey(_ type:Int, _ dic:[String:Any]) -> Bool{
        let key = dic["bleKey"] as? Int ?? 0
        let flag = dic["bleKeyFlag"] as? Int ?? 0
        let bleKey : BleKey = BleKey(rawValue: key) ?? .NONE
        let bleKeyFlag : BleKeyFlag = BleKeyFlag(rawValue: flag) ?? .NONE
        bleLog("sendBleKey - \(bleKey) \(bleKeyFlag) ")
        
        if mBleConnector.isAvailable() == false{
            bleLog("device disconnect")
        }
        
        if bleKey == .NONE && bleKeyFlag == .NONE{
            return false
        }
        var resultBool = false
        switch type {
        case 0:
            
            switch bleKey {
            case .TIME:
                //let timeObj = BleTime(2022, 11, 1, 8, 9, 12)  // test code
                let timeObj = getObject(bleKey, [:])  // get system time
                resultBool = mBleConnector.sendObject(bleKey, bleKeyFlag, timeObj)
                
            case .TIME_ZONE:
                let timeZoneObj = getObject(bleKey, [:])  // get system timezone
                resultBool = mBleConnector.sendObject(bleKey, bleKeyFlag, timeZoneObj)
            default:
                resultBool = mBleConnector.sendData(bleKey, bleKeyFlag)
            }
            
            break
        case 1:
            let sendValue = dic["value"] as? Bool ?? false
            resultBool = mBleConnector.sendBool(bleKey, bleKeyFlag,sendValue)
            break
        case 2:
            let sendValue = dic["value"] as? Int ?? 0
            resultBool = mBleConnector.sendInt8(bleKey, bleKeyFlag,sendValue)
            break
        case 3:
            let sendValue = dic["value"] as? Int ?? 0
            resultBool = mBleConnector.sendInt32(bleKey, bleKeyFlag,sendValue)
            break
        case 4:
           
            if bleKey == .SCHEDULE{
                let schudules : [[String:Any]] = dic["value"] as? [ [String:Any]] ?? []
                if schudules.count>0{
                    _ = mBleConnector.sendInt8(.SCHEDULE, .DELETE, ID_ALL)
                    for index in 0..<schudules.count{
                        let item = schudules[index]
                        resultBool = mBleConnector.sendObject(bleKey, bleKeyFlag,getObject(bleKey,item))
                    }
                }
            } else if bleKey == .WATCH_FACE {
                // 处理自定义表盘
                self.execCustomWatchFace(dic)
            }else{
                
                let sendValue = dic["value"] as? [String:Any] ?? [:]
                if bleKey == .CONTACT{
                    resultBool = mBleConnector.sendStream(bleKey, getObject(bleKey,sendValue)?.toData() ?? Data())
                }else if bleKey.isIdObjectKey() {
                    // id类型是特殊一点, 只能单独处理
                    resultBool = getIdObject(bleKey, bleKeyFlag, sendValue)
                } else if let sendObj = getObject(bleKey, sendValue) {
                    let sendWritable: BleWritable = sendObj
                    resultBool = mBleConnector.sendObject(bleKey, bleKeyFlag, sendWritable)
                } else {
                    bleLog("类型不匹配, 无法找到对应的对象")
                }
            }
            break
        case 5:
            let sendValue = dic["value"] as? String ?? ""
            if sendValue.count>5{
                resultBool = mBleConnector.sendStream(bleKey, sendValue)
            }
            break
        default:
            break
        }
        return resultBool
    }
    
    func getIdObject(_ bleKey:BleKey, _ bleKeyFlag: BleKeyFlag, _ dic:[String:Any]) -> Bool {
        
        var bleIdObject = BleIdObject()
        // 数据对象可能是 BleWritable, 也可能是 BleIdObject类型, 需要区分处理
        // 创建 BleIdObject 对象, 不同的指令参数不一致, 如果使用错误, 会导致发送时候类型转换失败, 而导致闪退
        var res = false
        switch bleKey {
        case .LOVE_TAP_USER:
            let obj = BleLoveTapUser().dictionaryToObjct(dic)
            res = mBleConnector.sendObject(bleKey, bleKeyFlag, obj)
        case .MEDICATION_REMINDER:
            let obj = BleMedicationReminder().dictionaryToObjct(dic)
            res = mBleConnector.sendObject(bleKey, bleKeyFlag, obj)
        case .ALARM:
            let obj = BleAlarm().dictionaryToObjct(dic)
            res = mBleConnector.sendObject(bleKey, bleKeyFlag, obj)
            
        default:
            bleLog("SMA ERROR getIdObject The key was not found:\(bleKey)")
            break
        }
        
        return res
    }
    
    /// 方法返回的数据对象可能是 BleWritable, 也可能是 BleIdObject类型, 需要区分处理
    /// 创建 BleIdObject 对象, 不同的指令参数不一致, 如果使用错误, 会导致发送时候类型转换失败, 而导致闪退
    func getObject(_ blekey:BleKey,_ dic:[String:Any])->BleWritable?{
        if blekey == .USER_PROFILE{
            return BleUserProfile().dictionaryToObjct(dic)
        }else if blekey == .SEDENTARINESS{
            return BleSedentarinessSettings().dictionaryToObjct(dic)
        }else if blekey == .NO_DISTURB_RANGE{
            return BleNoDisturbSettings().dictionaryToObjct(dic)
        }else if blekey == .HR_MONITORING{
            return BleHrMonitoringSettings().dictionaryToObjct(dic)
        }else if blekey == .WEATHER_REALTIME{
            return BleWeatherRealtime().dictionaryToObjct(dic)
        //}else if blekey == .WEATHER_FORECAST{
        //    return BleWeatherForecast().dictionaryToObjct(dic)
        }else if blekey == .WEATHER_FORECAST{
            return BleWeatherForecast().dictionaryToObjct(dic)
        }else if blekey == .TIME{
            return BleTime.local()
        }else if blekey == .TIME_ZONE{
            return BleTimeZone()
        }else if blekey == .SCHEDULE{
            return BleSchedule().dictionaryToObjct(dic)
        }else if blekey == .NOTIFICATION_REMINDER{
            return BleNotificationSettings().dictionaryToObjct(dic)
        }else if blekey == .GESTURE_WAKE{
            return BleGestureWake().dictionaryToObjct(dic)
        }else if blekey == .HEALTH_CARE{
            return BleHealthCare().dictionaryToObjct(dic)
        }else if blekey == .TEMPERATURE_DETECTING{
            return BleTemperatureDetecting().dictionaryToObjct(dic)
        }else if blekey == .CONTACT{
            return BleAddressBook().dictionaryToObjct(dic)
        } else if blekey == .LOVE_TAP {
            return BleLoveTap().dictionaryToObjct(dic)
        }
        
        var resObj = BleWritable()
        switch blekey {
        case .WEATHER_REALTIME2: // 推送 实时天气2
            resObj = BleWeatherRealtime2().dictionaryToObjct(dic)
        case .WEATHER_FORECAST2: // 推送 预报天气2
            resObj = BleWeatherForecast2().dictionaryToObjct(dic)
        case .HR_WARNING_SET:
            resObj = BleHrWarningSettings().dictionaryToObjct(dic)
        case .DRINKWATER:
            resObj = BleDrinkWaterSettings().dictionaryToObjct(dic)
        case .NEWS_FEER:
            resObj = BleNewsFeed().dictionaryToObjct(dic)
        default:
            bleLog("SMA ERROR getObject The key was not found:\(blekey)")
            break
        }
        
        return resObj
    }
     
    func unPair() {
        _ = mBleConnector.sendData(.IDENTITY, .DELETE)
        //clean device info
        self.mBleCache.putDeviceIdentify(nil)
        self.mBleCache.remove(BleKey.IDENTITY)
        self.mBleConnector.unbind()
    }
    
    
    //MARK: - 处理自定义表盘
    private func execCustomWatchFace(_ dic: [String: Any]) {
        
        guard let valueDic = dic["value"] as? [String: Any] else {
            bleLog("Custom watch face, value field data does not exist")
            return
        }
        
        guard let elementList = valueDic["elementList"] as? [[String: Any]] else {
            bleLog("Custom watch face, elementList field data does not exist")
            return
        }
        //print("自定义表盘elementList:\(elementList)")
        //print("============")
        
        var watchFaceElements = [Element]()
        for dic in elementList {
            
            let model = ABHElementConverModel(dic: dic)
            
            // 预览图元素, 必要的
            if model.type == WatchFaceBuilder.sharedInstance.ELEMENT_PREVIEW {
                
                let element = self.execNumberWatchFace(model)
                watchFaceElements.append(element)
            } else if model.type == WatchFaceBuilder.sharedInstance.ELEMENT_BACKGROUND { // 背景元素
                
                let element = self.execNumberWatchFace(model)
                watchFaceElements.append(element)
            } else if model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_STEP ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_HEART ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_CALORIE ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_DISTANCE {
                // 步数, 心率, 卡路里, 距离
                let element = self.execNumberWatchFace(model)
                watchFaceElements.append(element)
            } else if model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_AMPM ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_HOUR ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_MIN ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_MONTH ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_DAY ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_WEEKDAY {
                
                // AM/PM, 小时, 分钟, 月份, 日, 星期
                let element = self.execNumberWatchFace(model)
                watchFaceElements.append(element)
            } else if model.type == WatchFaceBuilder.sharedInstance.ELEMENT_NEEDLE_HOUR ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_NEEDLE_MIN ||
                        model.type == WatchFaceBuilder.sharedInstance.ELEMENT_NEEDLE_SEC {
                // 指针处理
                let element = self.execPointWatchFace(model)
                watchFaceElements.append(element)
            }
        }
        
        if watchFaceElements.count > 0 {
            
            var sendData: BleWatchFaceBin?
            if BleCache.shared.mSupport2DAcceleration > 0 {
                // 支持2D的设备, 必须使用faceBuilder.PNG_ARGB_8888
                // For devices that support 2D, faceBuilder.PNG_ARGB_8888 must be used
                sendData = buildWatchFace(watchFaceElements, watchFaceElements.count, Int32(WatchFaceBuilder.sharedInstance.PNG_ARGB_8888))
                bleLog("Support 2D dial bin file size - \(String(describing: sendData?.toData().count))")
            } else {
                // 不支持2D加速设备, 应该使用 faceBuilder.BMP_565 参数
                // 2D accelerated devices are not supported, you should use the faceBuilder.BMP_565 parameter
                sendData = buildWatchFace(watchFaceElements, watchFaceElements.count, Int32(WatchFaceBuilder.sharedInstance.BMP_565))
                bleLog("2D acceleration devices are not supported, bin file size - \(String(describing: sendData?.toData().count))")
            }
            
            if let safeData = sendData {
                if mBleConnector.sendStream(.WATCH_FACE, safeData.toData()) {
                    bleLog("sendStream - WATCH_FACE")
                }
            } else {
                bleLog("buildWatchFace watch face failed")
            }
        } else {
            bleLog("No custom watch face data needs to be sent")
        }
    }
    
    private func buildWatchFace(_ elements:[Element],_ elementCount:Int,_ imageFormat:Int32) ->BleWatchFaceBin{
        
        var imageCountStart = 0
        for item in elements {
            imageCountStart += Int(item.imageCount)
        }

        //header
        let bleBin = BleWatchFaceBin()
        bleBin.header = BleWatchFaceBinToHeader.init(ImageTotal: UInt16(imageCountStart), ElementCount: UInt8(elements.count), ImageFormat: UInt8(imageFormat))

        // ElementInfo[]
        var imageSizeIndex :UInt16 = 0
        let infoSize : Int = elementCount * BleWatchFaceBinElementInfo.ITEM_LENGTH
        bleBin.ElementInfo.removeAll()
        for i in 0..<elementCount {
            let newInfo = BleWatchFaceBinElementInfo.init(imageBufferOffset: 0, imageSizeIndex: imageSizeIndex, w: elements[i].w, h: elements[i].h, x: elements[i].x, y: elements[i].y, imageCount: elements[i].imageCount, type: elements[i].type, gravity: elements[i].gravity,ignoreBlack:  elements[i].ignoreBlack, bottomOffset: elements[i].bottomOffset, leftOffset: elements[i].leftOffset, reserved: 0)
            imageSizeIndex += UInt16(elements[i].imageCount)
            bleBin.ElementInfo.append(newInfo)
        }
        
        // uint32_t[] 所有图片的长度
        var elementImageBufferOffset : UInt32 = UInt32(BleWatchFaceBinToHeader.ITEM_LENGTH + infoSize+(4*imageCountStart))
        bleBin.imageCount.removeAll()
        for i in 0..<elementCount {
            bleBin.ElementInfo[i].infoImageBufferOffset = elementImageBufferOffset
            for j in 0..<Int(elements[i].imageSizes.count) {
                elementImageBufferOffset += elements[i].imageSizes[j]
                bleBin.imageCount.append(elements[i].imageSizes[j])
            }
        }

        // int8_t[] 所有图片buffer
        bleBin.imageBuffer.removeAll()
        for i in 0..<elementCount {
            bleBin.imageBuffer.append(elements[i].imageBuffer)
        }
        return bleBin
    }
    
    //MAKR: 处理数字表盘
    private func execNumberWatchFace(_ model: ABHElementConverModel) -> Element {
        
        var element = Element(type: model.type, isAlpha: 1)
        element.w = UInt16(model.w)
        element.h = UInt16(model.h)
        element.gravity = UInt8(model.gravity)
        element.ignoreBlack = UInt8(model.ignoreBlack)
        element.x = UInt16(model.x)
        element.y = UInt16(model.y)
        element.bottomOffset = UInt8(model.bottomOffset)
        element.leftOffset = UInt8(model.leftOffset)
        
        // 其他需要单独处理的参数
        let dataGroup = self.execImageConver(model.ignoreBlack, model.imagePaths, (model.hasAlpha > 0))
        element.imageCount = dataGroup.imageCount
        element.imageSizes = dataGroup.imageSizes
        element.imageBuffer = dataGroup.imageBuffer
        
        return element
    }
    
    private func execImageConver(_ ignoreBlack: Int, _ imagePaths: [String], _ hasAlpha: Bool) -> (imageCount: UInt8, imageSizes: [UInt32], imageBuffer: Data) {
        
        var imageCount :UInt8 = 0// 元素中图片的个数。
        var imageSizes :[UInt32] = []
        var imageBuffer :Data = Data() // 元素中所有图片的buffer
        for imgPath in imagePaths {
            
            guard let img = UIImage(contentsOfFile: imgPath), let pngData = img.pngData() else {
                bleLog("Image path imgPath failed to be created correctly:\(imgPath)")
                continue
            }
            if ignoreBlack == 4 {
                // 支持2D的处理
                let converByte = ImageConverTools.getImgWith(UIImage(data: pngData)!, isAlpha: hasAlpha)
                let newByte = self.customWatchFaceViewModel.byteAlignment(converByte)
                
                imageSizes.append(UInt32(newByte.count))
                imageBuffer.append(newByte)
            } else {
                // 不支持2D的处理
                guard let pvByte = UIImage(data: pngData)?.rearrangePixels(1.0).pixData else {
                    bleLog("2D devices are not supported and image data creation failed. imgPath:\(imgPath)")
                    continue
                }

                imageSizes.append(UInt32(pvByte.count))
                imageBuffer.append(pvByte)
            }
        }
        
        imageCount = UInt8(imageSizes.count)
        
        return (imageCount: imageCount, imageSizes: imageSizes, imageBuffer: imageBuffer)
    }
    
    
    //MAKR: 处理指针表盘
    private func execPointWatchFace(_ model: ABHElementConverModel) -> Element {
        
        var newElementModel = Element(type: model.type, isAlpha: 0)
        newElementModel.w = UInt16(model.w)
        newElementModel.h = UInt16(model.h)
        newElementModel.gravity = UInt8(model.gravity)
        newElementModel.ignoreBlack = UInt8(model.ignoreBlack)
        newElementModel.x = UInt16(model.x)
        newElementModel.y = UInt16(model.y)
        newElementModel.bottomOffset = UInt8(model.bottomOffset)
        newElementModel.leftOffset = UInt8(model.leftOffset)
        
        
        // 其他需要单独处理的参数
        let dataGroup = self.execPointImageConver(model.ignoreBlack, model.imagePaths, (model.hasAlpha != 0))
        newElementModel.imageCount = dataGroup.imageCount
        newElementModel.imageSizes = dataGroup.imageSizes
        newElementModel.imageBuffer = dataGroup.imageBuffer
        
        return newElementModel
    }
    
    private func execPointImageConver(_ ignoreBlack: Int, _ imagePaths: [String], _ hasAlpha: Bool) -> (imageCount: UInt8, imageSizes: [UInt32], imageBuffer: Data) {
        
        var imageCount :UInt8 = 0// 元素中图片的个数。
        var imageSizes :[UInt32] = []
        var imageBuffer :Data = Data() // 元素中所有图片的buffer
        for imgPath in imagePaths {
            
            guard let img = UIImage(contentsOfFile: imgPath), let newByte = img.rearrangePixels().pixData else {
                bleLog("Failed to create pointer image path imgPath correctly:\(imgPath)")
                continue
            }
            
            imageSizes.append(UInt32(newByte.count))
            imageBuffer.append(newByte)
        }
        
        imageCount = UInt8(imageSizes.count)
        
        return (imageCount: imageCount, imageSizes: imageSizes, imageBuffer: imageBuffer)
    }
    
    func setTargetDeviceUUID(_ uuid:String, _ bleConnectionType: BleConnectorType){
        mBleConnector.setTargetIdentifier(uuid, bleConnectionType)
    }
    
    func connectDevice(_ connect:Bool){
        mBleConnector.connect(connect)
    }
    
    func mBleConnectorCloseDeviceConnection(_ stopReconnecting:Bool){
        mBleConnector.closeConnection(stopReconnecting)
    }
    
    func pair() {
        if mBleConnector.sendData(.PAIR, .UPDATE) == false {
            bleLog("pair sended failed....")
        }else{
            bleLog("pair sended success....")
        }
    }
    
    func bleConnectorInvokeMethod(_ method:String,_ arguments:[String:Any?],_ timeOut:Double = 0.0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
            if (bleConnectorResult != nil){
                bleConnectorResult?.invokeMethod(method, arguments: arguments)
            }
        }
    }
    
    private func startOTA(filePath: String, mainServiceUUID: String, uuid: String) {
        
        self.ROTA2.startOTA(filePath: filePath, mainServiceUUID: mainServiceUUID, uuid: uuid)
    }
    
    

    
    /// 针对JL平台设备的OTA
    private func startJL_OTA(filePath: String, mainServiceUUID: String, uuid: String, isDfu: Bool, address: String) {
        
        #if DEBUG
        print("filePath:\(filePath)")
        print("mainServiceUUID:\(mainServiceUUID)")
        print("uuid:\(uuid)")
        print("address:\(address)")
        print("==========================")
        #endif
        
        jlOTA = JLFirmwareOTA(filePath: filePath, mainServiceUUID: mainServiceUUID, uuid: uuid, isDfu: isDfu, address: address)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.jlOTA?.startJL_OTA()
        }
    }
    
}


extension BleConnectorMethodChannel : BleHandleDelegate {
    
    
    //MARK: Connecte
    public func onDeviceConnecting(_ status: Bool) {
        bleLog("onDeviceConnecting ->status:\(status)")
        bleConnectorInvokeMethod(SdkMethod.onDeviceConnecting.rawValue, ["status":status])
    }
    
    //连接成功
    public func onDeviceConnected(_ peripheral: CBPeripheral) {
        
        bleLog("connection succeeded - \(peripheral.identifier.uuidString)")
        let newDevice : BleDevice = BleDevice.init(peripheral, [:], -10)
        bleConnectorInvokeMethod(callBackDeviceConnected,newDevice.toDictionary())
    }

    /// 绑定成功
    public func onIdentityCreate(_ status: Bool, _ deviceInfo: BleDeviceInfo?) {
        bleLog("Binding succeeded status:\(status) deviceInfo:\(String(describing: deviceInfo))")
        
        var newDevice: Any? = nil
        if status {
            newDevice = deviceInfo?.toDictionary(status)
        }
        
        bleConnectorInvokeMethod(SdkMethod.onIdentityCreate.rawValue, ["status":status, "deviceInfo": newDevice])
    }
    
    
    /// 设备返回ANCS状态触发
    @available(iOS 13.0, *)
    public func didUpdateANCSAuthorization(_ peripheral: CBPeripheral) {
        bleConnectorInvokeMethod(SdkMethod.didUpdateANCSAuthorization.rawValue, ["status": peripheral.ancsAuthorized])
    }
    
    /// 读取设备 BleAddress
    public func onReadBleAddress(_ address: String) {
        bleConnectorInvokeMethod(SdkMethod.onReadBleAddress.rawValue, ["address": address])
    }
    /// 读取设备信息返回
    public func onReadDeviceInfo(_ status: Bool, _ deviceInfo: BleDeviceInfo) {
        bleConnectorInvokeMethod(SdkMethod.onReadDeviceInfo.rawValue, deviceInfo.toDictionary(status))
    }
    /// 获取手表信息, 设备基础信息返回
    public func onReadDeviceInfo2(_ deviceInfo2: BleDeviceInfo2) {
        bleConnectorInvokeMethod(SdkMethod.onReadDeviceInfo2.rawValue, ["deviceInfo": deviceInfo2.toDictionary()])
    }
    
    public func onSessionStateChange(_ status: Bool) {
        if status{
            bleLog("connection succeeded. Necessary settings (time, time zone)")
        }
        self.pair()
        bleConnectorInvokeMethod(callBackSessionStateChange,["status":status])
    }
    
    public func onIdentityDelete(_ status: Bool) {
        bleConnectorInvokeMethod(callBackIdentityDelete,["status":status])
    }
    
    public func onIdentityDeleteByDevice(_ status: Bool) {
        bleConnectorInvokeMethod(callBackIdentityDeleteByDevice,["isDevice":status])
    }
    
    //MARK: data
    public func onReadPower(_ power: Int) {
        bleConnectorInvokeMethod(callBackReadPower,["power":power])
    }
    
    public func onReadFirmwareVersion(_ version: String) {
        bleConnectorInvokeMethod(callBackReadFirmwareVersion,["version":version])
    }
    
    public func onReadSedentariness(_ sedentarinessSettings: BleSedentarinessSettings) {
        bleConnectorInvokeMethod(callBackReadSedentariness,sedentarinessSettings.toDictionary())
    }
    
    public func onReadNoDisturb(_ noDisturbSettings: BleNoDisturbSettings) {
        bleConnectorInvokeMethod(SdkMethod.onReadNoDisturb.rawValue, noDisturbSettings.toDictionary())
    }
    
    public func onNoDisturbUpdate(_ noDisturbSettings: BleNoDisturbSettings) {
        bleConnectorInvokeMethod(callBackNoDisturbUpdate,noDisturbSettings.toDictionary())
    }
    
    public func onReadAlarm(_ alarms: [BleAlarm]) {
        var array1 : [[String:Any]] = []
        for item in alarms{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadAlarm,["list":array1])
    }
    
    public func onAlarmUpdate(_ alarm: BleAlarm) {
        bleConnectorInvokeMethod(callBackAlarmUpdate,alarm.toDictionary())
    }
    
    public func onAlarmDelete(_ id: Int) {
        bleConnectorInvokeMethod(callBackAlarmDelete,["id":id])
    }
    
    public func onAlarmAdd(_ alarm: BleAlarm) {
        bleConnectorInvokeMethod(callBackAlarmAdd,alarm.toDictionary())
    }
    
    public func onFindPhone(_ start: Bool) {
        bleConnectorInvokeMethod(callBackFindPhone,["start":start])
    }
    
    public func onReadUiPackVersion(_ version: String) {
        bleConnectorInvokeMethod(callBackReadUiPackVersion,["version":version])
    }
    
    public func onReadLanguagePackVersion(_ version: BleLanguagePackVersion) {
        bleConnectorInvokeMethod(callBackReadLanguagePackVersion,version.toDictionary())
    }
    
    public func onSyncData(_ syncState: Int, _ bleKey: Int) {
        bleConnectorInvokeMethod(callBackSyncData,["syncState":syncState,"bleKey":bleKey])
    }
    
    public func onReadActivity(_ activities: [BleActivity]) {
        var array1 : [[String:Any]] = []
        for item in activities{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadActivity,["list":array1])
    }
    
    public func onReadHeartRate(_ heartRates: [BleHeartRate]) {
        var array1 : [[String:Any]] = []
        for item in heartRates{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadHeartRate,["list":array1])
    }
    
    public func onUpdateRealTimeHR(_ itemHR: ABHRealTimeHR) {
        let hr : BleHeartRate = BleHeartRate()
        hr.mTime = itemHR.mTime
        hr.mBpm = itemHR.mHR
        bleConnectorInvokeMethod(callBackUpdateHeartRate,hr.toDictionary())
    }
    
    public func onReadBloodPressure(_ bloodPressures: [BleBloodPressure]) {
        var array1 : [[String:Any]] = []
        for item in bloodPressures{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadBloodPressure,["list":array1])
    }
    
    public func onReadSleep(_ sleeps: [BleSleep]) {
        var array1 : [[String:Any]] = []
        for item in sleeps{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadSleep,["list":array1])
    }
                                 
    public func onReadWorkOut(_ WorkOut: [BleWorkOut]) {
        var array1 : [[String:Any]] = []
        for item in WorkOut{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadWorkout,["list":array1])
    }
    
    public func onReadLocation(_ locations: [BleLocation]) {
        var array1 : [[String:Any]] = []
        for item in locations{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadLocation,["list":array1])
    }
    
    public func onReadTemperature(_ temperatures: [BleTemperature]) {
        var array1 : [[String:Any]] = []
        for item in temperatures{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadTemperature,["list":array1])
    }
    
    public func onReadBloodOxygen(_ bloodOxygens: [BleBloodOxygen]) {
        bleLog("onReadBloodOxygen ->bloodOxygen:\(bloodOxygens)")
                
        var array1 : [[String:Any]] = []
        for item in bloodOxygens {
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(SdkMethod.onReadBloodOxygen.rawValue, ["list":array1])
    }
    
    public func onReadHeartRateVariability(_ HeartRateVariability: [BleHeartRateVariability]) {
        var array1 : [[String:Any]] = []
        for item in HeartRateVariability{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadBleHrv,["list":array1])
    }
    
    public func onCameraStateChange(_ cameraState: Int) {
        bleConnectorInvokeMethod(callBackCameraStateChange,["cameraState":cameraState])
    }
    
    public func onCameraResponse(_ status: Bool, _ cameraState: Int) {
        bleConnectorInvokeMethod(callBackCameraResponse,["cameraState":cameraState,"status":status])
    }

    public func onStreamProgress(_ status: Bool, _ errorCode: Int, _ total: Int, _ completed: Int) {
        bleLog("onStreamProgress status - \(status) errorCode - \(errorCode) total - \(total) completed - \(completed)")
        bleConnectorInvokeMethod(callBackStreamProgress,["status":status,"errorCode":errorCode,"total":total,"completed":completed])
    }
    
    public func onPhoneGPSSport(_ workoutState: Int) {
//        bleConnectorInvokeMethod(callBackRequestLocation,["workoutState":workoutState])
    }
    
    public func onDeviceRequestAGpsFile(_ url: String) {
//        bleConnectorInvokeMethod(callBackDeviceRequestAGpsFile,["workoutState":url])
    }
    
//    func onIncomingCallStatus
    
    public func onReadPressures(_ pressures: [BlePressure]) {
        var array1 : [[String:Any]] = []
        for item in pressures{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(callBackReadPressure,["list":array1])
    }
    
    public func onFollowSystemLanguage(_ systemLanguage: Bool) {
//        bleConnectorInvokeMethod(callBackFollowSystemLanguage,["systemLanguage":systemLanguage])
    }
    
    public func onReadWeatherRealtime(_ update: Bool) {
//        bleConnectorInvokeMethod(callBackReadWeatherRealTime,["update":update])
    }
    
    public func onReadWorkOut2(_ WorkOut: [BleWorkOut2]) {
        var array1 : [[String:Any]] = []
        for item in WorkOut{
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(SdkMethod.onReadWorkout2.rawValue,["list":array1])
    }
    
    public func onCommandSendTimeout(_ bleKey: Int, _ bleKeyFlag: Int) {
        bleConnectorInvokeMethod(callBackCommandSendTimeout,["bleKey":bleKey,"bleKeyFlag":bleKeyFlag])
    }
    
    /// 设备的省电模式状态变化时触发
    public func onPowerSaveModeStateChange(_ state: Int) {
        bleConnectorInvokeMethod(SdkMethod.onPowerSaveModeStateChange.rawValue,["status":state])
    }
    
    
    /// 设备返回当前省电模式状态时触发
    /// - Parameter state: 状态
    public func onPowerSaveModeState(_ state: Int) {
        bleConnectorInvokeMethod(SdkMethod.onPowerSaveModeState.rawValue,["status":state])
    }
    
    /**
     * 设备返回当前抬手亮屏设置状态时触发。
     * @param state [BleGestureWake]
     */
    public func onReadGestureWake(_ bleGestureWake: BleGestureWake) {
        bleConnectorInvokeMethod(SdkMethod.onReadGestureWake.rawValue, bleGestureWake.toDictionary())
    }
    
    /**
     * 设备的抬手亮屏设置状态变化时触发。
     * @param state [BleGestureWake]
     */
    public func onGestureWakeUpdate(_ bleGestureWake: BleGestureWake) {
        bleConnectorInvokeMethod(SdkMethod.onGestureWakeUpdate.rawValue, bleGestureWake.toDictionary())
    }
    
    /// 读取小时制
    public func onReadHourSystem(_ value: Int) {
        bleConnectorInvokeMethod(SdkMethod.onReadHourSystem.rawValue, ["value": value])
    }
    
    public func onHourSystemUpdate(_ value: Int) {
        bleConnectorInvokeMethod(SdkMethod.onHourSystemUpdate.rawValue, ["value": value])
    }
    
    /// 读取背光
    public func onReadBacklight(_ value: Int) {
        bleConnectorInvokeMethod(SdkMethod.onReadBacklight.rawValue, ["value": value])
    }
    /**
     设备端修改背光设置时触发
     @param value [设置的背光值]
     */
    public func onBacklightUpdate(_ value: Int) {
        bleConnectorInvokeMethod(SdkMethod.onBacklightUpdate.rawValue, ["value":value])
    }
    
    /// 读取温度设置单位
    public func onReadTemperatureUnitSettings(_ value: Int) {
        // 设置温度单位 0:摄氏度℃  1:华氏温度℉
        bleConnectorInvokeMethod(SdkMethod.onReadTemperatureUnit.rawValue, ["value": value])
    }
    
    /// 读取日期格式设置
    public func onReadDateFormatSettings(_ value: Int) {
        
        /**
         * 日期格式设置
         * Date format Setting
         *
         * value 0 = "年/月/日"   "YYYY/MM/dd"
         * value 1 = "日/月/年"   "dd/MM/YYYY""
         * value 2 = "月/日/年"   "MM/dd/YYYY"
         */
        bleConnectorInvokeMethod(SdkMethod.onReadDateFormat.rawValue, ["value": value])
    }
    
    /**
     * 设备主动更新震动状态
     */
    public func onVibrationUpdate(_ value:Int) {
        // 取值范围0-10
        bleConnectorInvokeMethod(SdkMethod.onVibrationUpdate.rawValue, ["value": value])
    }
    
    /// 设备返回LoveTap 用户列表时触发
    /// - Parameter loveTapUsers: LoveTap 用户列表
    public func onReadLoveTapUser(_ loveTapUsers: [BleLoveTapUser]) {
        var array1 : [[String:Any]] = []
        for item in loveTapUsers {
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(SdkMethod.onReadLoveTapUser.rawValue,["list":array1])
    }
    
    /// 设备端修改LoveTap用户时触发
    /// - Parameter loveTapUser: LoveTap用户
    public func onLoveTapUserUpdate(_ loveTapUser: BleLoveTapUser) {
        bleConnectorInvokeMethod(SdkMethod.onLoveTapUserUpdate.rawValue, loveTapUser.toDictionary())
    }
    
    #warning("设备返回LoveTap 数据触发")
    /// 设备返回LoveTap 数据触发
    /// - Parameter loveTap: LoveTap 数据
    public func onLoveTapUpdate(_ loveTap: BleLoveTap) {
        
        if isLoveTapTest {
            //设置推送内容
            let content = UNMutableNotificationContent()
            content.title = "LoveTap"
            content.body = loveTap.description
            
            //设置通知触发器, 1秒后触发
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            //设置请求标识符
            let requestIdentifier = "com.sma.watch" + "\(loveTap.mTime)"
            
            //设置一个通知请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: nil)
            
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            }
        }
            
        bleConnectorInvokeMethod(SdkMethod.onLoveTapUpdate.rawValue, loveTap.toDictionary())
    }
    
    /// 设备端删除LoveTap用户时触发
    /// - Parameter id: 要删除用户的mId
    public func onLoveTapUserDelete(_ id: Int) {
        bleConnectorInvokeMethod(SdkMethod.onLoveTapUserDelete.rawValue, ["id":id])
    }
    
    
    /// 设备返回吃药提醒列表时触发
    /// - Parameter medicationReminders: 吃药提醒列表
    public func onReadMedicationReminder(_ medicationReminders: [BleMedicationReminder]) {
        var array1 : [[String:Any]] = []
        for item in medicationReminders {
            array1.append(item.toDictionary())
        }
        bleConnectorInvokeMethod(SdkMethod.onReadMedicationReminder.rawValue,["list":array1])
    }
    
    /// 设备端修改吃药提醒时触发
    /// - Parameter medicationReminder: 需要修改的吃药提醒
    public func onMedicationReminderUpdate(_ medicationReminder: BleMedicationReminder) {
        bleConnectorInvokeMethod(SdkMethod.onMedicationReminderUpdate.rawValue, medicationReminder.toDictionary())
    }
    
    /// 设备端删除吃药提醒时触发
    /// - Parameter id: 需要删除的吃药提醒mId
    public func onMedicationReminderDelete(_ id: Int) {
        bleConnectorInvokeMethod(SdkMethod.onMedicationReminderDelete.rawValue, ["id":id])
    }
    
    /// 设备返回心率设置时触发
    /// - Parameter hrMonitoringSettings: 心率设置数据
    public func onReadHrMonitoringSettings(_ hrMonitoringSettings: BleHrMonitoringSettings) {
        bleConnectorInvokeMethod(SdkMethod.onReadHrMonitoringSettings.rawValue, hrMonitoringSettings.toDictionary())
    }
    
    
    /// 读取设备端单位设置
    /// - Parameter id: 公制英制设置 0: 公制  1: 英制
    public func onReadUnit(_ id: Int) {
        bleConnectorInvokeMethod(SdkMethod.onReadUnit.rawValue, ["id":id])
    }
    
    
    /// 读取消息推送开关回调方法
    public func onReadNotificationSettings2(_ notificationSettings2: BleNotificationSettings2) {
        bleConnectorInvokeMethod(SdkMethod.onReadNotificationSettings2.rawValue, notificationSettings2.toDictionary())
    }
}
