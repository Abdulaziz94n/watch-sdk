//
//  BleEcgSettings.swift
//  SmartV3
//
//  Created by Coding on 2024/4/17.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 定时心电
open class BleEcgSettings: BleWritable {
    
    public var mBleTimeRange = BleTimeRange()
    /// 默认60分钟, 最小值1
    public var mInterval: Int = 60
    
    static let ITEM_LENGTH = 6
    override func decode() {
        super.decode()
        mBleTimeRange = readObject(BleTimeRange.ITEM_LENGTH)
        mInterval = Int(readUInt8())
    }
    
    override func encode() {
        super.encode()
        writeObject(mBleTimeRange)
        writeInt8(max(mInterval, 1))//最小为1
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mBleTimeRange = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange)
        mInterval = try container.decode(Int.self, forKey: .mInterval)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mBleTimeRange, forKey: .mBleTimeRange)
        try container.encode(mInterval, forKey: .mInterval)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mBleTimeRange, mInterval
    }
    
    open override var description: String {
        "BleEcgSettings(mBleTimeRange:\(mBleTimeRange), mInterval:\(mInterval))"
    }
}
