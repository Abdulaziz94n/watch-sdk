//
//  BleHanBaoVibration.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/7/10.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 鼾宝震动数据
open class BleHanBaoVibration: BleReadable {

    /// 距离当地2000/1/1 00:00:00的秒数
    public var mTime: Int = 0
    /// 震动强度等级
    public var mVibration: Int = 0
    /// 血氧值
    public var mBOValue: Int = 0
    
    static let ITEM_LENGTH = 8
    
    override func decode() {
        super.decode()
        
        mTime = Int(readUInt32())
        mVibration = Int(readUInt8())
        mBOValue = Int(readUInt8())
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mTime = try container.decode(Int.self, forKey: .mTime)
        mVibration = try container.decode(Int.self, forKey: .mVibration)
        mBOValue = try container.decode(Int.self, forKey: .mBOValue)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mTime, forKey: .mTime)
        try container.encode(mVibration, forKey: .mVibration)
        try container.encode(mBOValue, forKey: .mBOValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mTime, mVibration, mBOValue
    }
    
    
    open override var description: String {
        "BleHanBaoVibration(mTime:\(mTime), mVibration:\(mVibration), mBOValue:\(mBOValue))"
    }
}
