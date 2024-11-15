//
//  BlePhoneWorkOutStatus.swift
//  SmartV3
//
//  Created by SMA-IOS on 2021/12/24.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BlePhoneWorkOutStatus: BleWritable {
    static let ITEM_LENGTH = 2
    public var mMode: Int = 0
    public var mStatus = 0
    override var mLengthToWrite: Int {
        BlePhoneWorkOutStatus.ITEM_LENGTH
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mMode = try container.decode(Int.self, forKey: .wrokMode)
        mStatus = try container.decode(Int.self, forKey: .wrokStatus)

    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mMode, forKey: .wrokMode)
        try container.encode(mStatus, forKey: .wrokStatus)

    }

    private enum CodingKeys: String, CodingKey {
        case wrokMode, wrokStatus
    }
    
    public init(_ mode: Int, _ status: Int) {
        super.init()
        mMode = mode
        mStatus = status
    }
    
    override func encode() {
        super.encode()
        writeInt8(mMode)
        writeInt8(mStatus)
    }
    
    override func decode() {
        super.decode()
        mMode = Int(readInt8())
        mStatus = Int(readInt8())
    }
    
    open override var description: String {
        "BlePhoneWorkOutStatus(mMode: \(mMode), mStatus: \(mStatus))"
    }
}
open class PhoneWorkOutStatus {

    public static let Treadmill = 0x08
    public static let OutdoorRun = 0x09
    public static let Cycling = 0x0A
    public static let Climbing = 0x0D
    public static let modeStart = 0x01
    public static let modeContinues = 0x02
    public static let modePause = 0x03
    public static let modeEnd = 0x04
    /**
     mMode
     跑步机   0x08
     户外跑步 0x09
     骑行    0x0A
     爬山    0x0D
     
     mStatus
     运动开始 0x01
     运动继续 0x02
     运动暂停 0x03
     运动结束 0x04
     */
}
