//
//  BleBloodPressureCalibration.swift
//  SmartV3
//
//  Created by SMA-IOS on 2024/1/10.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

///血压标定
open class BleBloodPressureCalibration: BleWritable {

    /// 高压标定值（收缩压）
    public var mSystolic: Int = 0
    /// 低压标定值（舒张压）
    public var mDiastolic: Int = 0

    override var mLengthToWrite: Int {
        return 2
    }

    override func encode() {
        super.encode()
        
        writeInt8(mSystolic)
        writeInt8(mDiastolic)
    }
    
    override func decode() {
        super.decode()
        
        mSystolic = Int(readInt8())
        mDiastolic = Int(readInt8())
    }
    
//    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
//        super.init(data, byteOrder)
//    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mSystolic = try container.decode(Int.self, forKey: .mSystolic)
        mDiastolic = try container.decode(Int.self, forKey: .mDiastolic)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mSystolic, forKey: .mSystolic)
        try container.encode(mDiastolic, forKey: .mDiastolic)
    }

    private enum CodingKeys: String, CodingKey {
        case mSystolic, mDiastolic
    }
    
    open override var description: String {
        return "BleSOSSettings(mSystolic=\(mSystolic), mDiastolic=\(mDiastolic))"
    }
}
