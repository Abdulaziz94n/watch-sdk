//
//  BleEarphoneSoundEffectsSettings.swift
//  SmartV3
//
//  Created by Coding on 2024/2/23.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleEarphoneSoundEffectsSettings: BleWritable {
    
    /// 固定长度10
    static let DEFAULT_EQ_FREQS = [31, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]

    public var mMode: Int = 0
    public var mDynamic: Int = 0
    /// 固定长度10
    public var mValue: Data = Data()
    /// 固定长度10
    public var mFreqs: [Int] = BleEarphoneSoundEffectsSettings.DEFAULT_EQ_FREQS
    public var mCount: Int = 10
    
    
    
    private let ITEM_LENGTH = 34
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    
    override func encode() {
        super.encode()
        writeInt8(mMode)
        writeInt8(mDynamic)
        writeData(mValue)
        for it in mFreqs {
            writeInt16(it, .LITTLE_ENDIAN)
        }
        writeInt16(mCount, .LITTLE_ENDIAN)
    }

    override func decode() {
        super.decode()
        mMode = Int(readInt8())
        mDynamic = Int(readInt8())
        mValue = readData(10)
        for index in 0..<mFreqs.count {
            mFreqs[index] = Int(readInt16(.LITTLE_ENDIAN))
        }
        mCount = Int(readUInt16())
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mMode = try container.decode(Int.self, forKey: .mMode)
        mDynamic = try container.decode(Int.self, forKey: .mDynamic)
        mValue = try container.decode(Data.self, forKey: .mValue)
        mFreqs = try container.decode([Int].self, forKey: .mFreqs)
        mCount = try container.decode(Int.self, forKey: .mCount)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mMode, forKey: .mMode)
        try container.encode(mDynamic, forKey: .mDynamic)
        try container.encode(mValue, forKey: .mValue)
        try container.encode(mFreqs, forKey: .mFreqs)
        try container.encode(mCount, forKey: .mCount)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mMode, mDynamic, mValue, mFreqs, mCount
    }

    
    open override var description: String {
        return "BleEarphoneSoundEffectsSettings(mMode=\(mMode), mDynamic=\(mDynamic), mValue=\(mValue), mFreqs=\(mFreqs), mCount=\(mCount))"
    }
}


public enum BleEarphoneSoundEffectsType: Int {
    /// 自然
    case MODE_NORMAL = 0x00
    /// 摇滚
    case MODE_ROCK = 0x01
    /// 流行
    case MODE_POP = 0x02
    /// 经典
    case MODE_CLASSICAL = 0x03
    /// 爵士
    case MODE_JAZZ = 0x04
    /// 乡村
    case MODE_COUNTRY = 0x05
    /// 自定义
    case MODE_USER = 0x06
}
