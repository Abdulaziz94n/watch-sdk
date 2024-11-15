//
//  BleHmTime.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/11/30.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

open class BleHmTime: BleWritable {

    static let ITEM_LENGTH = 2
    
    override var mLengthToWrite: Int {
        return BleHmTime.ITEM_LENGTH
    }
    
    public var mHour: Int = 0
    public var mMinute: Int = 0
    
    public init(mHour: Int, mMinute: Int) {
        super.init()
        self.mHour = mHour
        self.mMinute = mMinute
    }
    
    override func encode() {
        super.encode()
        writeInt8(mHour)
        writeInt8(mMinute)
    }
    
    override func decode() {
        super.decode()
        mHour = Int(readUInt8())
        mMinute = Int(readUInt8())
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)

        mHour = try container.decode(Int.self, forKey: .mHour)
        mMinute = try container.decode(Int.self, forKey: .mMinute)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mHour, forKey: .mHour)
        try container.encode(mMinute, forKey: .mMinute)
    }

    private enum CodingKeys: String, CodingKey {
        case mHour, mMinute
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleHmTime {
        let newModel = BleHmTime()
        newModel.mHour = dic["mHour"] as? Int ?? 0
        newModel.mMinute = dic["mMinute"] as? Int ?? 0
        return newModel
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mHour":mHour,
                                    "mMinute":mMinute]
        return dic
    }
    
    open override var description: String {
        "BleHmTime(mHour: \(mHour), mMinute: \(mMinute))"
    }
}
