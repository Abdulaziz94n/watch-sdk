//
//  BleScannerMethodChannel.swift
//  coding_dev_flutter_sdk
//
//  Created by SMA-IOS on 2022/6/9.
//

import Foundation
import Flutter
import UIKit
import CoreBluetooth

public class BleScannerMethodChannel: NSObject, FlutterPlugin {
    
    let mBleConnector = BleConnector.shared
    var mBleScanner : BleScanner?
    var deviceSource = [BleDevice]()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
        let codec = FlutterJSONMethodCodec.sharedInstance()
        let channel = FlutterMethodChannel(name: _channelPrefix+"/ble_scanner", binaryMessenger: registrar.messenger(), codec: codec)
        scannerResult = channel
        let instance = BleScannerMethodChannel()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any?> ?? [:]
        bleLog("BleScannerMethodChannel - \( call.method)")
        if call.method.elementsEqual(mBleScannerBuild){
            let mDuration = args["duration"] as? Int ?? 10
            initBleScanner(Double(mDuration))
        }else if call.method.elementsEqual(mBleScannerScan){
            let mScan = args["scan"] as? Bool ?? false
            self.setBleScanner(mScan)
        }else if call.method.elementsEqual(mBleScannerExit){
            self.endBleScanner()
        } else if call.method == SdkMethod.onRetrieveConnectedPeripherals.rawValue {
            
            //获取当前系统已经配对的设备列表
            let conDevices = mBleScanner?.getConnectedDevices() ?? [BleDevice]()
            
            var jsonArray = [[String:Any]]()
            for item in conDevices {
                
                let itemDic = item.toDictionary()
                jsonArray.append(itemDic)
            }
            
            // 将结果, 返回给方法
            result(["list": jsonArray])
        } else if call.method == SdkMethod.onRetrieveConnectedDeviceUUID.rawValue {
            
            let uuidString = BleCache.shared.mDeviceInfo?.mIdentifier
            result(["uuidString": uuidString])
        }
  
    }
}

extension BleScannerMethodChannel{
    
    func initBleScanner(_ mDuration:Double){
        mBleScanner = BleScanner()
        mBleScanner!.mScanDuration = mDuration
        mBleScanner!.mBleScanDelegate = self
        mBleScanner!.mBleScanFilter = self
    }
    
    func endBleScanner(){
        mBleScanner!.mBleScanDelegate = nil
        mBleScanner!.mBleScanFilter = nil
        mBleScanner!.mCentralManager.stopScan()
    }
    
    func setBleScanner(_ scan:Bool){
        
        mBleScanner!.scan(scan)
    }
}

extension BleScannerMethodChannel: BleScanDelegate, BleScanFilter {
    
    // MARK: - BleScanDelegate
    public func onBluetoothDisabled() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if (scannerResult != nil){
                scannerResult?.invokeMethod(BleScanBluetoothDisabled, arguments: true)
            }
        }
    }

    public func onBluetoothEnabled() {
        
    }

    public func onScan(_ scan: Bool) {
        if scan {
            bleLog("start search")
        } else {
            bleLog("Searching completed")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if (scannerResult != nil){
                scannerResult?.invokeMethod(BleScanOnScan, arguments: scan)
            }
        }
        
    }

    public func onDeviceFound(_ device: BleDevice) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if (scannerResult != nil) && device.name.count>0{
                scannerResult?.invokeMethod(BleScanDeviceFound, arguments: device.toDictionary())
            }
        }
        
    }

    // MARK: - BleScanFilter
    public func match(_ device: BleDevice) -> Bool {
        if device.mRssi < -88 || device.address.count == 0 {
            return false
        }
        return true
    }
}


