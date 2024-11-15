//
//  JLFirmwareRepairBleDeviceModel.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/3/31.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

class JLFirmwareRepairBleDeviceModel: NSObject {

    var mPeripheral: CBPeripheral
    var mAdvertisementData: [String: Any]
    var mRssi: Int

    
    /// 如果是JL OTA 失败的的情况, 他们广播数据是不一样的, 所以需要区分下
    /// 例如这个广播数据: OTA失败: <d6054154 4f4c4a01 dfba7b6b cbf60200 81005200>
    /// d605开头, 代表JL设备,  41544f 这个几个对应的ASCII为: ATO, 正好为OTA 倒这来的
    var name: String {
        
        var deviceName = mPeripheral.name ?? ""
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] as? Data, manufactureData.count > 15 else {
            return deviceName
        }
        
        // 杰里广播以: D605开头
        guard manufactureData[0] == 0xD6 && manufactureData[1] == 0x05 else{
            return deviceName
        }
        
        // 2-4位的倒序数据, 使用ascii转换为字符串后得到OTA
        let data = Data(manufactureData[2...4].reversed())
        let otaTitle = String(data: data, encoding: .ascii) ?? ""
        
        if otaTitle == "OTA" || otaTitle == "ota" {
            deviceName = otaTitle + "_" + deviceName
        }
        
        return deviceName
    }

    var identifier: String {
        mPeripheral.identifier.uuidString
    }

    /// 如果是JL OTA 失败的的情况, 他们广播数据是不一样的, 所以需要区分下
    /// 例如这个广播数据: OTA失败: <d6054154 4f4c4a01 dfba7b6b cbf60200 81005200>
    /// d605开头, 代表JL设备
    /// 设备正确Mac地址: f6cb6b7 badf, 也是和这个广播数据到这来的 dfba7b6bcbf6
    var ota_address: String {
        
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] as? Data, manufactureData.count > 15 else {
            return identifier
        }
        
        // 杰里广播以: D605开头
        guard manufactureData[0] == 0xD6 && manufactureData[1] == 0x05 else{
            return identifier
        }
        
        let data = Data(manufactureData[8...13].reversed())
        let macStr = String(format: "%02X:%02X:%02X:%02X:%02X:%02X", data[0], data[1], data[2], data[3], data[4], data[5])
        
        return macStr
    }
    
    /// 杰里设备是否ota模式
    public func isJLOTA() -> Bool {
        
        var isOTA = false
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] as? Data, manufactureData.count > 15 else {
            return isOTA
        }
        
        // 杰里广播以: D605开头
        guard manufactureData[0] == 0xD6 && manufactureData[1] == 0x05 else{
            return isOTA
        }
        
        // 2-4位的倒序数据, 使用ascii转换为字符串后得到OTA
        let data = Data(manufactureData[2...4].reversed())
        let otaTitle = String(data: data, encoding: .ascii) ?? ""
        
        if otaTitle == "OTA" || otaTitle == "ota" {
            isOTA = true
        }
        
        return isOTA
    }
    
    
    public var address: String {
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] else {
            return identifier
        }
        guard let data = manufactureData as? Data else {
            return identifier
        }
        
        
        if data.count > 21{
            //杰里广播mac地址
            if data[14] == 0x43 && data[15] == 0x44{
                return String(format: "%02X:%02X:%02X:%02X:%02X:%02X",
                              data[16], data[17], data[18], data[19], data[20], data[21])
            }
        }
        
        
        // 思澈平台的广播数据 <010020c4 00914344 11223344 56f4>
        // 3444是‘C’‘D' 后面 是mac地址
        if data.count >= 14 {
            
            if data[6] == 0x43 && data[7] == 0x44 {
                return String(format: "%02X:%02X:%02X:%02X:%02X:%02X", data[8], data[9], data[10], data[11], data[12], data[13])
            }
        }
        
        // 指定客户广播数据
        if data.count > 11 {
            if data[0] == 0x1C && data[1] == 0x52 {
                return String(format: "%02X:%02X:%02X:%02X:%02X:%02X", data[7], data[6], data[8], data[11], data[10], data[9])
            }
        }
        
        if data.count >= 8 {
            return String(format: "%02X:%02X:%02X:%02X:%02X:%02X",
                          data[2], data[3], data[4], data[5], data[6], data[7])
        }
        
        
        return identifier
    }
    
    /// 如果是JL OTA 失败的的情况, 他们广播数据是不一样的, 所以需要区分下
    /// 例如这个广播数据: OTA失败: <d6054154 4f4c4a01 dfba7b6b cbf60200 81005200>
    /// d605开头, 代表JL设备,  41544f 这个几个对应的ASCII为: ATO, 正好为OTA 倒这来的
    var isJLDevice: Bool {
        
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] as? Data, manufactureData.count > 15 else {
            return false
        }
        
        // 杰里广播以: D605开头
        guard manufactureData[0] == 0xD6 && manufactureData[1] == 0x05 else{
            return false
        }
        
        return true
    }

    init(_ peripheral: CBPeripheral, _ advertisementData: [String: Any], _ RSSI: NSNumber) {
        mPeripheral = peripheral
        mAdvertisementData = advertisementData
        mRssi = RSSI.intValue
    }
    
    @objc init(_ peripheral: CBPeripheral, _ advertisementData: [String: Any], _ RSSI: NSNumber, _ flag: String = "") {
        mPeripheral = peripheral
        mAdvertisementData = advertisementData
        mRssi = RSSI.intValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        if object == nil || !(object! is BleDevice) {
            return false
        }

        return identifier == (object as! BleDevice).identifier
    }

    override var description: String {
        "JLFirmwareRepairBleDeviceModel(name: \(name), identifier: \(identifier), mRssi: \(mRssi)), mAdvertisementData: \(mAdvertisementData))"
    }
}
