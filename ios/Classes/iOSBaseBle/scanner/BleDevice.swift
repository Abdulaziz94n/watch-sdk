//
//  BleDevice.swift
//  blesdk3
//
//  Created by Best Mafen on 2019/9/17.
//  Copyright © 2019 szabh. All rights reserved.
//

import CoreBluetooth

open class BleDevice: NSObject {
    public var mPeripheral: CBPeripheral
    public var mAdvertisementData: [String: Any]
    public var mRssi: Int

    public var name: String {
        mPeripheral.name ?? ""
    }

    public var identifier: String {
        mPeripheral.identifier.uuidString
    }
    
    private func getItelDeviceMac(_ advData: Data) -> String? {
        
        guard advData.count > 6 else {
            return nil
        }
        
        let pid = String(format: "%02X%02X%02X%02X", advData[2], advData[3], advData[4], advData[5])
        guard pid == "0002101E" else {
            return nil
        }
        
        guard let safeDic = mAdvertisementData["kCBAdvDataServiceData"] as? [CBUUID?: Data?], let firstDic = safeDic.first else {
            return nil
        }
        
        guard var macData = firstDic.key?.data else {
            return nil
        }
        guard let value = firstDic.value else {
            return nil
        }
        
        macData.append(value)
        
        if macData.count > 5 {
            return String(format: "%02X:%02X:%02X:%02X:%02X:%02X",
                          macData[1], macData[0], macData[2], macData[3], macData[4], macData[5])
        } else {   
            return nil
        }
    }

    public var address: String {
        //解析mac地址
        guard let manufactureData = mAdvertisementData["kCBAdvDataManufacturerData"] else {
            return identifier
        }
        guard let data = manufactureData as? Data else {
            return identifier
        }
        

        do {
           // 0xOO
            //bleLog("data.count : \(data.count)")
            // 判断是否为传音的设备
            if let safeItelMac = self.getItelDeviceMac(data) {
                return safeItelMac
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
        } catch {
            bleLog("parse mac error:\(error)")
        }
        
        
        return identifier
    }
    
    /// 如果是JL OTA 失败的的情况, 他们广播数据是不一样的, 所以需要区分下
    /// 例如这个广播数据: OTA失败: <d6054154 4f4c4a01 dfba7b6b cbf60200 81005200>
    /// d605开头, 代表JL设备
    /// 设备正确Mac地址: f6cb6b7 badf, 也是和这个广播数据到这来的 dfba7b6bcbf6
    public var ota_address: String {
        
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
    

    public init(_ peripheral: CBPeripheral, _ advertisementData: [String: Any], _ RSSI: NSNumber) {
        mPeripheral = peripheral
        mAdvertisementData = advertisementData
        mRssi = RSSI.intValue
    }

    open override func isEqual(_ object: Any?) -> Bool {
        
        guard let safeObj = object as? BleDevice else {
            return false
        }

        return identifier == safeObj.identifier
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
    
    
    
    /// 是否为tuya的设备, 如果是, 不要返回mac地址
    public func isTuYaDevice() -> Bool {
        
        guard let advDataServiceUUIDs = mAdvertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID], !advDataServiceUUIDs.isEmpty else {
            return false
        }
        
        return advDataServiceUUIDs.contains(CBUUID(string: "FD50"))
    }


    open override var description: String {
        "BleDevice(name:\(name), identifier:\(identifier), address:\(address), mRssi:\(mRssi)), mAdvertisementData:\(mAdvertisementData))"
    }
    
    
    // 这个是之前的方法, 注意返回的 mAddress 值
    //func toDictionary()->[String:Any]{
    //    let dic : [String : Any] = [
    //        "mName":name,
    //        "mAddress":identifier,
    //        "mRssi":mRssi,
    //        "mMac":self.address
    //    ]
    //    return dic
    //}
    /// 返回JSON数据, 这里一定需要注意mAddress 有些客户是根据mac地址连接, 有些客户要求使用uuid连接, 这里需要作区分返回不同的数据
    public func toDictionary()->[String:Any]{
        
        
        let isDfu = self.isJLOTA()
        var dic : [String : Any] = [
            "mName":name,
            "mAddress":self.address,  // 千万注意这个数据值
            "identifier":identifier,
            "mRssi":mRssi,
            "isDfu": isDfu
            
        ]
        
        // 如果处于Dfu模式, 设备的mac地址是不一样的, 需要重新赋值
        if isDfu {
            dic["mAddress"] = self.ota_address  // 千万注意这个数据值是OTA的mac
        }
        
        return dic
    }
}
