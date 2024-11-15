//
//  RealtekOTABridging.swift
//  sma_coding_dev_flutter_sdk
//
//  Created by 叩鼎科技 on 2023/4/18.
//

import UIKit
import CoreBluetooth

class RealtekOTABridging: NSObject {
    
    static let instance = RealtekOTABridging()
    private override init() {}
    
    private let ROTA2 = RealtekOTA2.sharedInstance()
    
    
    private var bleManager: CBCentralManager?
    private var bleManagerState: CBManagerState = .unknown
    private var bleCurrentPeripheral: CBPeripheral?

    /// OTA 文件路径
    private var filePath = ""
    private var mainServiceUUID = ""
    private var uuidString = ""
    
    func startOTA(filePath: String, mainServiceUUID: String, uuid: String) {
        
        self.filePath = filePath
        self.mainServiceUUID = mainServiceUUID
        self.uuidString = uuid
        
        bleLog("需要OTA的mainServiceUUID:\(mainServiceUUID)")
        bleLog("需要OTA的uuidString:\(uuidString)")
        
        // 初始化蓝牙中心
        bleManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    private func realtekStartOTA(_ filePath:String, _ peripheral: CBPeripheral){
        /*
          1. refreshUI -> true  upgrade firmware bin
             refreshUI -> false upgrade UI or font bin
          2.up to 3 files at once
          3.when multiple files are upgraded at the same time, please upgrade the firmware first.
         */
        
        self.ROTA2?.otaCallBack = { [weak self] (status, error, totalBytesCount, sendBytesCount) in

            bleLog("otaCallBack error:\(String(describing: error))")
            bleLog("status:\(status), totalBytesCount:\(totalBytesCount), sendBytesCount:\(sendBytesCount)")
            switch status {
                
            case .verifyFile, .readyForUpgrade:
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_PREPARE.rawValue, "progress":0, "error":""])
                
            case .upgradeFailed:  // 升级失败
                let errStr = error.debugDescription
                bleLog("OTA Error:\(errStr)")
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":errStr])
                self?.ROTA2?.uuidString = nil
                self?.ROTA2?.filePath = nil
                self?.ROTA2?.otaCallBack = nil
                
            case .duringUpgrade, .didFinishSending: // 发送文件中, 发送完成都执行这个方法
                let pro = sendBytesCount / totalBytesCount;
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_UPGRADEING.rawValue, "progress":pro, "error":""])
            case .upgradeSucceed: // 升级成功
                self?.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_DONE.rawValue, "progress":1, "error":""])
                self?.ROTA2?.uuidString = nil
                self?.ROTA2?.filePath = nil
                self?.ROTA2?.otaCallBack = nil
                
                self?.uuidString = ""
                self?.filePath = ""
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                    //Restart the device, connect ble
                    self?.reconnectDevice()
                }
                
            default:
                bleLog("OTA exec enum default")
                break
            }
        }
        self.ROTA2?.startUpgrade(with: peripheral, andPath: filePath)
        
    }
    
    private func execNewOTA(peripheral: CBPeripheral) {
        //let binPath = self.ROTA2?.filePath ?? ""
        // 我们的SDK断开连接, 让OTA去连接设备传输数据
        self.bleManager?.cancelPeripheralConnection(peripheral)
        self.realtekStartOTA(self.filePath, peripheral)
    }
    
    func reconnectDevice(){
        bleLog("reconnectDevice - \( BleConnector.shared.isAvailable())")
        if BleConnector.shared.isAvailable() == false{
            BleConnector.shared.launch()//reconnect Bluetooth
            DispatchQueue.main.asyncAfter(deadline: .now()+8.0) {
                self.reconnectDevice()
            }
        }
        
    }
    
    func bleConnectorInvokeMethod(_ method:String,_ arguments:[String:Any?],_ timeOut:Double = 0.0){
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
            if (bleConnectorResult != nil){
                bleConnectorResult?.invokeMethod(method, arguments: arguments)
            }
        }
    }
}


extension RealtekOTABridging: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        bleManagerState = central.state
        
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
            self.startScanBLE()
            default:
                bleLog("ble-> default")
        }
    }
    
    private func startScanBLE() {
        
        bleLog("startScanBLE 方法执行")
        
        // 在执行扫描之前, 判断当前配对的设备列表
        var isNext = true
        if let connectedPeripherals = bleManager?.retrieveConnectedPeripherals(withServices: [CBUUID(string: mainServiceUUID)]) {
            
            for conPer in connectedPeripherals {
                if conPer.identifier.uuidString == self.uuidString {
                    
                    // 需要OTA的设备存在已经配对的设备列表里面 不用去搜索了
                    isNext = false
                    
                    bleLog("需要OTA的设备存在已经配对的设备列表里面")
                    self.execNewOTA(peripheral: conPer)
                }
            }
        }
        
        guard isNext else {
            bleLog("需要OTA的设备存在已经配对的设备列表里面, 不用执行扫描其他外设")
            return
        }
        
        if let tempBleM = bleManager, tempBleM.state == .poweredOn {
            bleManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            
            bleLog("蓝牙异常, 请检查是否开启蓝牙")
            
            let err = NSError(domain: "Bluetooth is abnormal, please check whether Bluetooth is turned on", code: 1005)
            self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":err.description])
        }
    }
    
    func connectionError(_ errorStr: String) {
        
        if let currPer = self.bleCurrentPeripheral {
            bleLog("connectionError disconnectBLE.")
            self.bleManager?.cancelPeripheralConnection(currPer)
            self.bleCurrentPeripheral = nil
        }
        
        self.bleConnectorInvokeMethod(SdkMethod.onOTAProgress.rawValue, ["otaStatus": OTAStatus.OTA_FAILED.rawValue, "progress":0, "error":errorStr])
    }
    
    
    // 发现新设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.identifier.uuidString == self.uuidString {
            
            // 搜索到正确的UUID, 执行链接操作
            bleLog("搜索到正确的UUID, 执行链接操作, peripheral:\(peripheral)")
            self.bleCurrentPeripheral = peripheral
            
            // 这个时候代表是执行OTA连接, 连接成功, 执行OTA方法
            execNewOTA(peripheral: peripheral)
        }
    }
    
    // 设备连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        bleLog("BLE Connected ---> Device:\(String(describing: peripheral.name))")
        
        // 连接成功后，查找服务
        //peripheral.discoverServices(nil)
    }
    // 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        bleLog("Err:BLE Connect FAIL ---> Device:\(String(describing: peripheral.name))  Error:\(String(describing: error))")
                
        // 连接失败, 告知用户
        self.connectionError(String(describing: error))
    }
    
    // 设备断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        bleLog("BLE Disconnect ---> Device:\(String(describing: peripheral.name))  Error:\(String(describing: error))")
        self.bleCurrentPeripheral = nil
    }
}

//MARK: - 设备服务回调
extension RealtekOTABridging: CBPeripheralDelegate {
    
    
}

