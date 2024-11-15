//
//  BleGoMoreSettings.swift
//  SmartV3
//
//  Created by Coding on 2024/3/14.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleGoMoreSettings: BleWritable {

    /// UUID utf-8
    public var mUuid: String = ""
    /// UUID utf-8
    public var mKey: String = ""
    /// 类型,  0: 测试版本,旧的方式;  1: lite;  2: Pro
    var mType: Int = 0
    
    public var mUuidLength = 0
    public var mKeyLength = 0
    
    override var mLengthToWrite: Int {
        return 4 + mUuidLength + mKeyLength
    }
    
    override func encode() {
        super.encode()
        
        let uuidData = mUuid.data(using: .utf8) ?? Data()
        mUuidLength = uuidData.count
        writeInt8(mUuidLength)
        writeData(uuidData)
        let keyData = mKey.data(using: .utf8) ?? Data()
        mKeyLength = keyData.count
        writeInt8(mKeyLength)
        writeData(keyData)
        writeInt8(1)
        writeInt8(mType)
    }
    
    override func decode() {
        super.decode()
        mUuidLength = Int(readInt8())
        mUuid = String(data: readData(mUuidLength), encoding: .utf8) ?? ""
        mKeyLength = Int(readInt8())
        mKey = String(data: readData(mKeyLength), encoding: .utf8) ?? ""
        _ = readInt8()
        mType = Int(readInt8())
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mUuid = try container.decode(String.self, forKey: .mUuid)
        mUuidLength = try container.decode(Int.self, forKey: .mUuidLength)
        mKey = try container.decode(String.self, forKey: .mKey)
        mKeyLength = try container.decode(Int.self, forKey: .mKeyLength)
        mType = try container.decode(Int.self, forKey: .mType)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mUuid, forKey: .mUuid)
        try container.encode(mUuidLength, forKey: .mUuidLength)
        try container.encode(mKey, forKey: .mKey)
        try container.encode(mKeyLength, forKey: .mKeyLength)
        try container.encode(mType, forKey: .mType)
    }

    private enum CodingKeys: String, CodingKey {
        case mUuid, mUuidLength, mKey, mKeyLength, mType
    }
    
    open override var description: String {
        return "BleGoMoreSettings(mUuid=\(mUuid), mKey=\(mKey), mUuidLength=\(mUuidLength), mKeyLength=\(mKeyLength), mType=\(mType))"
    }
}
