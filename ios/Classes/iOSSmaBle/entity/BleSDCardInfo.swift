//
//  BleSDCardInfo.swift
//  SmartV3
//
//  Created by Coding on 2023/11/20.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleSDCardInfo: BleReadable {

    /// SD卡总空间大小, 单位KB
    public var mTotalSize: UInt = 0
    /// SD卡剩余可用空间大小, 单位KB
    public var mFreeSize: UInt = 0
    /// SD卡族大小, 单位KB
    public var mClustSize: UInt = 0

    static let ITEM_LENGTH = 12
    override func decode() {
        super.decode()
        mTotalSize = UInt(readUInt32())
        mFreeSize = UInt(readUInt32())
        mClustSize = UInt(readUInt8())
        // 其他3字节预留
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mTotalSize = try container.decode(UInt.self, forKey: .mTotalSize)
        mFreeSize = try container.decode(UInt.self, forKey: .mFreeSize)
        mClustSize = try container.decode(UInt.self, forKey: .mClustSize)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mTotalSize, forKey: .mTotalSize)
        try container.encode(mFreeSize, forKey: .mFreeSize)
        try container.encode(mClustSize, forKey: .mClustSize)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mTotalSize, mFreeSize, mClustSize
    }
    
    open override var description: String {
        "BleSDCardInfo(mTotalSize:\(mTotalSize), mFreeSize:\(mFreeSize), mClustSize:\(mClustSize))"
    }

}
