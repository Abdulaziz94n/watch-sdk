//
//  BleEcg.swift
//  SmartV3
//
//  Created by Coding on 2024/4/17.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 心电
open class BleEcg: BleReadable {
    
    /// 距离当地 2000/1/1 00:00:00 的秒值
    public var mTime: Int = 0
    /// 值
    public var mValue: Int = 0
    
    static let ITEM_LENGTH = 6
    override func decode() {
        super.decode()
        
        mTime = Int(readInt32())
        mValue = Int(readUInt8())
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mTime = try container.decode(Int.self, forKey: .mTime)
        mValue = try container.decode(Int.self, forKey: .mValue)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mTime, forKey: .mTime)
        try container.encode(mValue, forKey: .mValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mTime, mValue
    }
    
    open override var description: String {
        "BleEcg(mTime:\(mTime), mValue:\(mValue))"
    }
}
