//
//  BleBloodOxyGenSettings.swift
//  SmartV3
//
//  Created by SMA-IOS on 2022/1/17.
//  Copyright © 2022 KingHuang. All rights reserved.
//

import Foundation

open class BleBloodOxyGenSettings: BleWritable {
    
    public var mBleTimeRange = BleTimeRange()
    public var mInterval = 60 //默认60分钟
    
    static let ITEM_LENGTH = 6
    override var mLengthToWrite: Int {
        BleBloodOxyGenSettings.ITEM_LENGTH
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mBleTimeRange = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange)
        mInterval = try container.decode(Int.self, forKey: .mInterval)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mBleTimeRange, forKey: .mBleTimeRange)
        try container.encode(mInterval, forKey: .mInterval)
    }

    private enum CodingKeys: String, CodingKey {
        case mBleTimeRange, mInterval
    }
    
    override func encode() {
        super.encode()
        writeObject(mBleTimeRange)
        writeInt8(mInterval)
    }
    
    override func decode() {
        super.decode()
        mBleTimeRange = readObject(BleTimeRange.ITEM_LENGTH)
        mInterval = Int(readUInt8())
    }
    
    open override var description: String {
        "BleBloodOxyGenSettings(mBleTimeRange:\(mBleTimeRange), mInterval:\(mInterval))"
    }
}


