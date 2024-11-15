//
//  BleRingVibrationSettings.swift
//  SmartV3
//
//  Created by Coding on 2024/3/14.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 铃声和震动设置
open class BleRingVibrationSettings: BleWritable {

    /// 0代表关闭;  1代表开启
    public var mVibration: Int = 0
    public var mRing: Int = 0
    
    override var mLengthToWrite: Int {
        return 4
    }
    
    override func encode() {
        super.encode()
        writeInt8(mVibration)
        writeInt8(mRing)
        // 保留
        writeInt8(0)
        writeInt8(0)
    }
    
    override func decode() {
        super.decode()
        mVibration = Int(readInt8())
        mRing = Int(readInt8())
        // 保留
        _ = Int(readInt8())
        _ = Int(readInt8())
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mVibration = try container.decode(Int.self, forKey: .mVibration)
        mRing = try container.decode(Int.self, forKey: .mRing)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mVibration, forKey: .mVibration)
        try container.encode(mRing, forKey: .mRing)
    }

    private enum CodingKeys: String, CodingKey {
        case mVibration, mRing
    }
    
    open override var description: String {
        return "BleRingVibrationSettings(mVibration=\(mVibration), mRing=\(mRing))"
    }
}
