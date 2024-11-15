//
//  BleEarphoneKey.swift
//  SmartV3
//
//  Created by Coding on 2024/8/23.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 耳机按键
open class BleEarphoneKey: BleWritable {

    public var mLeftClick: Int = 0 //左耳单击
    public var mLeftDoubleClick: Int = 0 //左耳双击
    public var mLeftTripleClick: Int = 0 //左耳三击
    public var mLeftLongClick: Int = 0   //左耳长按
    public var mRightClick: Int = 0  //右耳单击
    public var mRightDoubleClick: Int = 0 //右耳双击
    public var mRightTripleClick: Int = 0 //右耳三击
    public var mRightLongClick: Int = 0 //右耳长按
    
    private let ITEM_LENGTH = 8
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mLeftClick)
        writeInt8(mLeftDoubleClick)
        writeInt8(mLeftTripleClick)
        writeInt8(mLeftLongClick)
        writeInt8(mRightClick)
        writeInt8(mRightDoubleClick)
        writeInt8(mRightTripleClick)
        writeInt8(mRightLongClick)
    }
    
    override func decode() {
        super.decode()
        mLeftClick = Int(readInt8())
        mLeftDoubleClick = Int(readInt8())
        mLeftTripleClick = Int(readInt8())
        mLeftLongClick = Int(readInt8())
        mRightClick = Int(readInt8())
        mRightDoubleClick = Int(readInt8())
        mRightTripleClick = Int(readInt8())
        mRightLongClick = Int(readInt8())
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mLeftClick = try container.decode(Int.self, forKey: .mLeftClick)
        mLeftDoubleClick = try container.decode(Int.self, forKey: .mLeftDoubleClick)
        mLeftTripleClick = try container.decode(Int.self, forKey: .mLeftTripleClick)
        mLeftLongClick = try container.decode(Int.self, forKey: .mLeftLongClick)
        mRightClick = try container.decode(Int.self, forKey: .mRightClick)
        mRightDoubleClick = try container.decode(Int.self, forKey: .mRightDoubleClick)
        mRightTripleClick = try container.decode(Int.self, forKey: .mRightTripleClick)
        mRightLongClick = try container.decode(Int.self, forKey: .mRightLongClick)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mLeftClick, forKey: .mLeftClick)
        try container.encode(mLeftDoubleClick, forKey: .mLeftDoubleClick)
        try container.encode(mLeftTripleClick, forKey: .mLeftTripleClick)
        try container.encode(mLeftLongClick, forKey: .mLeftLongClick)
        try container.encode(mRightClick, forKey: .mRightClick)
        try container.encode(mRightDoubleClick, forKey: .mRightDoubleClick)
        try container.encode(mRightTripleClick, forKey: .mRightTripleClick)
        try container.encode(mRightLongClick, forKey: .mRightLongClick)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mLeftClick, mLeftDoubleClick, mLeftTripleClick, mLeftLongClick, mRightClick, mRightDoubleClick
        case mRightTripleClick, mRightLongClick
    }
    
    
    open override var description: String {
        return "BleEarphoneKey(mLeftClick=\(mLeftClick), mLeftDoubleClick=\(mLeftDoubleClick), mLeftTripleClick=\(mLeftTripleClick), mLeftLongClick=\(mLeftLongClick), mRightClick=\(mRightClick), mRightDoubleClick:\(mRightDoubleClick), mRightTripleClick:\(mRightTripleClick), mRightLongClick:\(mRightLongClick))"
    }
}

public enum BleEarphoneKeyType: Int {
    /// 未选择
    case KEY_NONE = 0
    /// 上一曲
    case KEY_PRE = 0x01
    /// 下一曲
    case KEY_NEXT = 0x02
    /// 播放/暂停
    case KEY_PLAY_PAUSE = 0x03
    /// 切换环境音
    case KEY_SWITCH_ENV = 0x04
    /// 加音量
    case KEY_VOL_UP = 0x05
    /// 减音量
    case KEY_VOL_DOWN = 0x06
    /// 语音助手
    case KEY_VOICE_ASSISTANT = 0x07
}
