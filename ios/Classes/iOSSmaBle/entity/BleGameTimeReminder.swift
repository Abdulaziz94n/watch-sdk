//
//  BleGameTimeReminder.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/8/7.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleGameTimeReminder: BleWritable {

    /// 0:关闭;  1:开启
    public var mEnabled: Int = 0
    /// 设置的分钟, 0-59
    public var mMinute: Int = 0

    override var mLengthToWrite: Int {
        return 4
    }

    override func encode() {
        super.encode()
        
        writeInt8(mEnabled)
        writeInt8(mMinute)
        writeInt16(0)  // 预留
    }
    
    override func decode() {
        super.decode()
        
        mEnabled = Int(readInt8())
        mMinute = Int(readInt8())
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mMinute = try container.decode(Int.self, forKey: .mMinute)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mMinute, forKey: .mMinute)
    }

    private enum CodingKeys: String, CodingKey {
        case mEnabled, mMinute
    }
    
    open override var description: String {
        return "BleGameTimeReminder(mEnabled=\(mEnabled), mMinute=\(mMinute))"
    }
}
