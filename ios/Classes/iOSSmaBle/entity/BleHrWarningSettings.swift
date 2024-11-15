//
//  BleHrWarningSettings.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/6.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

open class BleHrWarningSettings: BleWritable {
    

    /// 心率过高提醒开关
    public var mHighSwitch: Int = 0
    /// 过高心率提醒阈值
    public var mHighValue: Int = 0
    /// 心率过低提醒开关
    public var mLowSwitch: Int = 0
    /// 过低心率提醒阈值
    public var mLowValue: Int = 0
    
    
    private let ITEM_LENGTH = 4
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mHighSwitch)
        writeInt8(mHighValue)
        writeInt8(mLowSwitch)
        writeInt8(mLowValue)
    }

    override func decode() {
        super.decode()
        mHighSwitch = Int(readInt8())
        mHighValue = Int(readInt8())
        mLowSwitch = Int(readUInt8())
        mLowValue = Int(readUInt8())
    }
    
    
    
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mHighSwitch = try container.decode(Int.self, forKey: .mHighSwitch)
        mHighValue = try container.decode(Int.self, forKey: .mHighValue)
        mLowSwitch = try container.decode(Int.self, forKey: .mLowSwitch)
        mLowValue = try container.decode(Int.self, forKey: .mLowValue)
    }
    
    
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mHighSwitch, forKey: .mHighSwitch)
        try container.encode(mHighValue, forKey: .mHighValue)
        try container.encode(mLowSwitch, forKey: .mLowSwitch)
        try container.encode(mLowValue, forKey: .mLowValue)
    }

    private enum CodingKeys: String, CodingKey {
        case mHighSwitch, mHighValue
        case mLowSwitch, mLowValue
    }
    
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    
    open override var description: String {
        return "BleHrWarningSettings(mHighSwitch=\(mHighSwitch), mHighValue=\(mHighValue), mLowSwitch=\(mLowSwitch), mLowValue=\(mLowValue))"
    }
    

    
    public func toDictionary()->[String:Int]{
        let dic = [
            "mHighSwitch":mHighSwitch,
            "mHighValue":mHighValue,
            "mLowSwitch":mLowSwitch,
            "mLowValue":mLowValue,
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleHrWarningSettings {

        let newModel = BleHrWarningSettings()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mHighSwitch = dic["mHighSwitch"] as? Int ?? 0
        newModel.mHighValue = dic["mHighValue"] as? Int ?? 0
        newModel.mLowSwitch = dic["mLowSwitch"] as? Int ?? 0
        newModel.mLowValue = dic["mLowValue"] as? Int ?? 0
        return newModel
    }
}
