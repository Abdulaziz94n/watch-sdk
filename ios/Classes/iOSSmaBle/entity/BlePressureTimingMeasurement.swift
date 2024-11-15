//
//  BlePressureTimingMeasurement.swift
//  SmartV3
//
//  Created by Coding on 2023/10/11.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BlePressureTimingMeasurement: BleWritable {

    override var mLengthToWrite: Int {
        1 + BleTimeRange.ITEM_LENGTH
    }

    public var mBleTimeRange = BleTimeRange()
    public var mInterval: Int = 0 // 分钟数

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()
        writeObject(mBleTimeRange)
        writeInt8(mInterval > 0 ? mInterval : 1)  // mInterval 设置的最小值为1
    }

    override func decode() {
        super.decode()
        mBleTimeRange = readObject(BleTimeRange.ITEM_LENGTH)
        mInterval = Int(readUInt8())
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

    open override var description: String {
        "BlePressureTimingMeasurement(mBleTimeRange: \(mBleTimeRange), mInterval: \(mInterval))"
    }
}
