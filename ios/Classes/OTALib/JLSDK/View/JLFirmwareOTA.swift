//
//  JLFirmwareRepairSelectViewController.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/3/31.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit
import CoreBluetooth

class JLFirmwareOTA: NSObject {
    
    private let kFLT_BLE_FOUND        = "FLT_BLE_FOUND"            //发现设备
    private let kFLT_BLE_PAIRED       = "FLT_BLE_PAIRED"           //BLE已配对
    private let kFLT_BLE_CONNECTED    = "FLT_BLE_CONNECTED"        //BLE已连接
    private let kFLT_BLE_DISCONNECTED = "FLT_BLE_DISCONNECTED"     //BLE断开连接

    private let FLT_BLE_SERVICE = "AE00" //服务号
    private let FLT_BLE_RCSP_W  = "AE01" //命令“写”通道
    private let FLT_BLE_RCSP_R  = "AE02" //命令“读”通道
    
    private var bleManager: CBCentralManager?
    private var bleManagerState: CBManagerState = .unknown
    private var bleCurrentPeripheral: CBPeripheral?
    private var isDfu = false

    private var mAssist = JL_Assist()
    
    /// OTA 文件路径
    private var filePath = ""
    private var mainServiceUUID = ""
    private var uuidString = ""
    private var address = ""
    
    /// 连接设备时候, 如果连接时间超过30s就取消连接, 用户可以再次点击链接设备
    //private var connecTime: Timer?
    private var lastBleMacAddress = ""
    
    /*--- 连接超时管理 ---*/
    //private var linkTimer: Timer?
    
    init(filePath: String, mainServiceUUID: String, uuid: String, isDfu: Bool, address: String) {
        super.init()
        
        self.mAssist.mPairKey    = nil;             //配对秘钥（或者自定义配对码pairData）
        self.mAssist.mService    = FLT_BLE_SERVICE; //服务号
        self.mAssist.mRcsp_W     = FLT_BLE_RCSP_W;  //特征「写」
        self.mAssist.mRcsp_R     = FLT_BLE_RCSP_R;  //特征「读」
        
        
        // 初始化蓝牙中心
        bleManager = CBCentralManager(delegate: self, queue: nil)
        
        // 增加监听JL SDK 如果连接到设备, 执行回调
        JL_Tools.add(kQCY_BLE_PAIRED, action: #selector(noteEntityConnected(_:)), own: self)
        
        
        self.filePath = filePath
        self.mainServiceUUID = mainServiceUUID
        self.uuidString = uuid
        self.isDfu = isDfu
        self.address = address
        
        bleLog("需要OTA的mainServiceUUID:\(mainServiceUUID)")
        bleLog("需要OTA的uuidString:\(uuidString)")
        bleLog("需要OTA的isDfu:\(isDfu), address:\(address)")
    }
    
    public func startJL_OTA() {
        
        // OTA 与操作
        self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_PREPARE.rawValue, "progress":0.0, "error":""])
        
        // 在执行扫描之前, 判断当前配对的设备列表
        var isNext = true
        if let connectedPeripherals = bleManager?.retrieveConnectedPeripherals(withServices: [CBUUID(string: mainServiceUUID)]) {
            
            for conPer in connectedPeripherals {
                if conPer.identifier.uuidString == self.uuidString {
                    
                    // 需要OTA的设备存在已经配对的设备列表里面 不用去搜索了
                    isNext = false
                    
                    bleLog("需要OTA的设备存在已经配对的设备列表里面")
                    self.connectDevice(peripheral: conPer)
                }
            }
        }
        
        guard isNext else {
            bleLog("需要OTA的设备存在已经配对的设备列表里面, 不用执行扫描其他外设")
            return
        }
        
        if bleManagerState == .poweredOn {
            bleManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            
            bleLog("蓝牙异常, 请检查是否开启蓝牙")
            
            let err = NSError(domain: "Bluetooth is abnormal, please check whether Bluetooth is turned on", code: 1005)
            self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error":err.description])
        }
    }
    
    /// 连接设备
    private func connectDevice(peripheral: CBPeripheral) {
        
        // 一定要引用, 否则对象销毁了
        self.bleCurrentPeripheral = peripheral
        self.bleCurrentPeripheral?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.bleManager?.connect(peripheral)
        }
    }
    
    
    
    // 设备配对成功后返回的数据, 这里校验设备是否正常? 如果正常设备提示用户即可, 不正常, 需要修复
    @objc private func noteEntityConnected(_ note: Notification) {
        
        bleLog("JL固件修复, 请求的版本信息")
        self.mAssist.mCmdManager.cmdTargetFeatureResult { [weak self] (status, sn, data) in
            
            bleLog("cmdTargetFeatureResult, status:\(status.rawValue), sn:\(sn), data:\(String(describing: data))")
            guard status == .success else {
                print(NSLocalizedString("newWeight_sdkerror", comment: "未能检测到设备,请重试"))
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error": "Failed to detect device, please try again"])
                return
            }
            
            guard let model = self?.mAssist.mCmdManager.outputDeviceModel() else{
                
                bleLog("获取outputDeviceModel 模型失败")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error": "Failed to get the outputDeviceModel model"])
                return
            }
            
            let upSt = model.otaStatus
            if (upSt == .force) {
                bleLog("JL_OtaStatusForce ---> 进入强制升级,跳至升级界面，执行OTA升级");
            } else {
                bleLog("设备正常使用, 无需OTA --->To disconnectBLE.")
            }
            
            if let binFile = self?.filePath {
                self?.senderFirmwareBinFile(binFile)
            }
        }
    }
    
    private func senderFirmwareBinFile(_ binPath: String) {
        
        bleLog("JsenderFirmwareBinFile, 发送固件数据")
        let localURL = URL(fileURLWithPath: binPath)
        
        var tempData: Data?
        do {
            tempData = try Data(contentsOf: localURL)
        } catch {
            
            bleLog("senderFirmwareBinFile Data(contentsOf: localURL) 转换失败error:\(error)")
            self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error": error.localizedDescription])
            return
        }
        
        guard let otaData = tempData else {
            bleLog("senderFirmwareBinFile otaData 转换失败")
            self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error": "OTA binary bin file data is empty"])
            return
        }
        
        //self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_PREPARE.rawValue, "progress":0.0, "error":""])
        /*--- 开始OTA升级 ---*/
        self.mAssist.mCmdManager.mOTAManager.cmdOTAData(otaData) { [weak self] result, progress in
            
            bleLog("firmware repair, cmdOTAData, result:\(result)")
            bleLog("firmware repair, cmdOTAData, progress:\(progress)")
            if result == .prepared {
                bleLog("OTA准备完成: prepared")
            } else if result == .reboot {
                bleLog("OTA需要重启设备: reboot")
            } else if (result == .preparing) {
                
                print("OTA文件校验中:\(progress)")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_CHECKING.rawValue, "progress":progress, "error":""])
            } else if result == .upgrading {
                
                print("OTA升级中upgrading:\(progress)")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_UPGRADEING.rawValue, "progress":progress, "error":""])
            }else if (result == .success) {
                
                print("升级成功result:\(result)")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_DONE.rawValue, "progress":0.0, "error":""])
            }else if (result == .reconnectWithMacAddr) {
                
                if let model = self?.mAssist.mCmdManager.outputDeviceModel() {
                    self?.lastBleMacAddress = model.bleAddr
                    self?.startScanBLE()
                    print("---> OTA正在通过Mac Addr方式回连设备... %@", model.bleAddr);
                } else {
                    print("---> OTA正在通过Mac Addr方式回连设备, flage=2")
                }
                
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_UPGRADEING.rawValue, "progress":progress, "error":"OTA is running normally, and OTA is connecting back to the device through Mac Addr"])
            }else{
                var message = ""
                if (result == .fail) {
                    print("OTA升级失败")
                    message = "JL_OTAResultFail";
                }else if (result == .dataIsNull) {
                    print("OTA升级数据为空!")
                    message = "JL_OTAResultDataIsNull";
                }else if (result == .commandFail) {
                    print("OTA指令失败!");
                    message = "JL_OTAResultCommandFail";
                }else if (result == .seekFail) {
                     print("OTA标示偏移查找失败");
                    message = "JL_OTAResultSeekFail";
                }else if (result == .infoFail) {
                     print("OTA升级固件信息错误!");
                    message = "JL_OTAResultInfoFail";
                }else if (result == .lowPower) {
                     print("OTA升级设备电压低!");
                    message = "JL_OTAResultLowPower";
                }else if (result == .enterFail) {
                     print("未能进入OTA升级模式!");
                    message = "JL_OTAResultEnterFail";
                }else if (result == .unknown) {
                     print("OTA未知错误!");
                    message = "JL_OTAResultUnknown";
                }else if (result == .failSameVersion) {
                    print("相同版本!");
                    message = "JL_OTAResultFailSameVersion";
                } else {
                    message = "Error Code: \(result.rawValue)"
                }
                
                
                print("OTA进展错误数据message:\(message)")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0.0, "error": message])
            }
        }
    }
    
    //MARK: - 开始扫描
    private func startScanBLE() {
        
        print("BLE ---> startScanBLE.")
        if self.bleManager?.state == .poweredOn {
            self.bleManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func connectionError(_ errorStr: String) {
        
        //KRProgressHUD.showError(withMessage: errorStr)
        
        if let currPer = self.bleCurrentPeripheral {
            bleLog("connectionError disconnectBLE.")
            self.bleManager?.cancelPeripheralConnection(currPer)
            self.bleCurrentPeripheral = nil
        }
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func bleConnectorInvokeMethod(_ method:String,_ arguments:[String:Any?],_ timeOut:Double = 0.0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
            if (bleConnectorResult != nil){
                bleConnectorResult?.invokeMethod(method, arguments: arguments)
            }
        }
    }
}

extension JLFirmwareOTA: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        bleManagerState = central.state
        self.mAssist.assistUpdate(central.state)
        
        switch central.state {
            case .unknown:
                bleLog("ble-> unknown")
            case .resetting:
                bleLog("ble-> resetting")
            case .unsupported:
                 bleLog("ble-> unsupported")
            case .unauthorized:
                 bleLog("ble-> unauthorized")
            case .poweredOff:
                 bleLog("ble-> poweredOff")
            case .poweredOn:
                 bleLog("ble-> poweredOn")
                 //reconnectTimer("")
            default:
                bleLog("ble-> default")
        }
    }
    
    
    // 发现新设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.identifier.uuidString == self.uuidString {
            
            // 搜索到正确的UUID, 执行链接操作
            bleLog("搜索到正确的UUID, 执行链接操作, peripheral:\(peripheral)")
            self.bleCurrentPeripheral = peripheral
            
            // 这个时候代表是执行OTA连接, 连接成功, 执行OTA方法
            connectDevice(peripheral: peripheral)
        } else {
            
            bleLog("可能是处于回连设备")
            //let ble_name = advertisementData["kCBAdvDataLocalName"] as? String ?? ""
            let ble_AD   = advertisementData["kCBAdvDataManufacturerData"] as? Data ?? Data()
            //let info = JL_BLEAction.bluetoothKey_1(self.mAssist.mPairKey ?? Data(), filter: advertisementData)
            //[JL_BLEAction bluetoothKey_1:self.mAssist.mPairKey Filter:advertisementData];
            
            
            if self.isDfu {
                
                let bleDevice = JLFirmwareRepairBleDeviceModel(peripheral, advertisementData, RSSI)
                
                #if DEBUG
                bleLog("搜到的isJLOTA:\(bleDevice.isJLOTA())")
                bleLog("搜到的name:\(bleDevice.name)")
                bleLog("搜到的name:\(bleDevice.mAdvertisementData)")
                bleLog("搜到的mac:\(bleDevice.address)")
                bleLog("搜到的ota_address:\(bleDevice.ota_address)")
                #endif
                if self.address == bleDevice.ota_address || self.address == bleDevice.address {
                    // ota升级过程，回连使用
                    self.connectDevice(peripheral: peripheral)
                    self.bleManager?.stopScan()
                    
                    self.isDfu = false
                }
                
            } else {
                
                //if ble_name.isEmpty {
                //    return
                //}
                
                //print("发现 ----> NAME:\(ble_name) AD:\(ble_AD)")


                
                // ota升级过程，回连使用
                if JL_BLEAction.otaBleMacAddress(self.lastBleMacAddress, isEqualToCBAdvDataManufacturerData: ble_AD) {
                    self.connectDevice(peripheral: peripheral)
                    self.bleManager?.stopScan()
                }
            }
        }
    }
    
    /// 设备连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        bleLog("BLE Connected ---> Device:\(String(describing: peripheral.name))")
        JL_Tools.post(kQCY_BLE_CONNECTED, object: peripheral)
    
        // 连接成功后，查找服务
        peripheral.discoverServices(nil)
    }
    /// 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        bleLog("Err:BLE Connect FAIL ---> Device:\(String(describing: peripheral.name))  Error:\(String(describing: error))")
        
        JL_Tools.post(kQCY_BLE_ERROR, object: NSNumber(4006))
        
        // 连接失败, 告知用户
        self.connectionError(NSLocalizedString("Device_Firmware_OTAFail", comment: "OTA连接失败,请重试"))
    }
    
    // 设备断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        bleLog("BLE Disconnect ---> Device:\(String(describing: peripheral.name))  Error:\(String(describing: error))")
        self.bleCurrentPeripheral = nil
        self.mAssist.assistDisconnectPeripheral(peripheral)
        
        /*--- UI刷新，设备断开 ---*/
        JL_Tools.post(kQCY_BLE_DISCONNECTED, object: peripheral)
    }
}

//MARK: - 设备服务回调
extension JLFirmwareOTA: CBPeripheralDelegate {
    
    // 设备服务回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let tempErr = error {
            print("Err: Discovered services fail. error:\(tempErr)")
            return
        }
        
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
    
    // 设备特性回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let tempErr = error {
            print("Err: Discovered Characteristics fail. 特征ererr:\(tempErr)")
            return
        }
        
        self.mAssist.assistDiscoverCharacteristics(for: service, peripheral: peripheral)
    }
    
    
    //MARK: 更新通知特征的状态
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if let tempErr = error {
            print("Err: Update NotificationState For Characteristic fail. ererr:\(tempErr)")
            return
        }
        
        self.mAssist.assistUpdate(characteristic, peripheral: peripheral) {[weak self] isPaired in
            
            if isPaired {

                JL_Tools.setUser(peripheral.identifier.uuidString, forKey: kUUID_BLE_LAST)
                //self.lastBleMacAddress = @"";
                //self.isConnect = YES;
                //self->_mBlePeripheral = peripheral;
                /*--- UI配对成功 ---*/
                JL_Tools.post(kQCY_BLE_PAIRED, object: peripheral)
            } else {
                self?.bleManager?.cancelPeripheralConnection(peripheral)
            }
                
        }
    }
    
    // 设备返回的数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let tempErr = error {
            print("Err: receive data fail. error:\(tempErr)")
            return
        }
        self.mAssist.assistUpdateValue(for: characteristic)
    }
}
