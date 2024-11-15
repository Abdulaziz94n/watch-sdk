//
//  BleEarphoneInfo.swift
//  SmartV3
//
//  Created by Coding on 2024/3/6.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 耳机信息
open class BleEarphoneInfo: BleReadable {

    public var mBleAddress: String = ""
    public var mFirmwareVersion: String = "0.0.0"
    public var mBleName: String = ""
    public var mFirmwareFlag: String = ""
    
    override func decode() {
        super.decode()
        mBleAddress = toMacAdress(bytes: readData(6))  //readStringUtil(0).uppercased()
        mFirmwareVersion = toVersion(bytes: readData(3), separator: ".")
        mBleName = readStringUtil(0)
        mFirmwareFlag = readStringUtil(0)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mBleAddress = try container.decode(String.self, forKey: .mBleAddress)
        mFirmwareVersion = try container.decode(String.self, forKey: .mFirmwareVersion)
        mBleName = try container.decode(String.self, forKey: .mBleName)
        mFirmwareFlag = try container.decode(String.self, forKey: .mFirmwareFlag)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mBleAddress, forKey: .mBleAddress)
        try container.encode(mFirmwareVersion, forKey: .mFirmwareVersion)
        try container.encode(mBleName, forKey: .mBleName)
        try container.encode(mFirmwareFlag, forKey: .mFirmwareFlag)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mBleAddress, mFirmwareVersion, mBleName, mFirmwareFlag
    }
    
    private func toVersion(bytes: Data, separator: String) -> String {
        
        return bytes.map {
            if $0 > 9 {
                return "0"
            } else {
                return "\($0)"
            }
        }.joined(separator: separator)
    }
    
    private func toMacAdress(bytes: Data) -> String {
        var bArr : [String] = []
        for byte in bytes {
            bArr.append(String(format: "%02x", byte).uppercased())
        }
        
        if bArr.count > 0 {
            return bArr.joined(separator: ":")
        }else {
            return ""
        }
       
    }
    
    open override var description: String {
        return "BleEarphoneInfo(mBleAddress=\(mBleAddress), mFirmwareVersion=\(mFirmwareVersion), mBleName=\(mBleName), mFirmwareFlag=\(mFirmwareFlag))"
    }
}
