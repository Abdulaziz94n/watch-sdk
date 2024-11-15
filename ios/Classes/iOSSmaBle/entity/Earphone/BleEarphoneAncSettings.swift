//
//  BleEarphoneAncSettings.swift
//  SmartV3
//
//  Created by Coding on 2024/2/23.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleAncMode: BleWritable {
    
    public var mLeftMax: Int = 0
    public var mRightMax: Int = 0
    public var mLeftCurVal: Int = 0
    public var mRightCurVal: Int = 0
    
    public static let ITEM_LENGTH = 8
    override var mLengthToWrite: Int {
        return BleAncMode.ITEM_LENGTH
    }
    
    public init(mLeftMax: Int, mRightMax: Int, mLeftCurVal: Int, mRightCurVal: Int) {
        super.init()
        
        self.mLeftMax = mLeftMax
        self.mRightMax = mRightMax
        self.mLeftCurVal = mLeftCurVal
        self.mRightCurVal = mRightCurVal
    }
    
    override func encode() {
        super.encode()
        writeInt16(mLeftMax, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mRightMax, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mLeftCurVal, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mRightCurVal, ByteOrder.LITTLE_ENDIAN)
    }

    override func decode() {
        super.decode()
        mLeftMax = Int(readUInt16(.LITTLE_ENDIAN))
        mRightMax = Int(readUInt16(.LITTLE_ENDIAN))
        mLeftCurVal = Int(readUInt16(.LITTLE_ENDIAN))
        mRightCurVal = Int(readUInt16(.LITTLE_ENDIAN))
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mLeftMax = try container.decode(Int.self, forKey: .mLeftMax)
        mRightMax = try container.decode(Int.self, forKey: .mRightMax)
        mLeftCurVal = try container.decode(Int.self, forKey: .mLeftCurVal)
        mRightCurVal = try container.decode(Int.self, forKey: .mRightCurVal)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mLeftMax, forKey: .mLeftMax)
        try container.encode(mRightMax, forKey: .mRightMax)
        try container.encode(mLeftCurVal, forKey: .mLeftCurVal)
        try container.encode(mRightCurVal, forKey: .mRightCurVal)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mLeftMax, mRightMax, mLeftCurVal, mRightCurVal
    }

    open override var description: String {
        return "BleAncMode(mLeftMax=\(mLeftMax), mRightMax=\(mRightMax), mLeftCurVal=\(mLeftCurVal), mRightCurVal=\(mRightCurVal))"
    }
}

/**
 * 耳机降噪设置，参考杰里的结构
 */
open class BleEarphoneAncSettings: BleWritable {
    
    public static let MODE_CLOSE = 0 //关闭
    public static let MODE_DENOISE = 1 //降噪
    public static let MODE_TRANSPARENT = 2 //通透
    
    /// 当前降噪模式
    public var mMode: Int = 0
    /// 3个模式的详细设置, 这里设置初始值主要是避免忘记
    public var mAncModeList: [BleAncMode] = [
        //MODE_CLOSE
        BleAncMode(mLeftMax: 0, mRightMax: 0, mLeftCurVal: 0, mRightCurVal: 0),
        //MODE_DENOISE
        BleAncMode(mLeftMax: 16384, mRightMax: 16384, mLeftCurVal: 8000, mRightCurVal: 8000),
        //MODE_TRANSPARENT
        BleAncMode(mLeftMax: 16384, mRightMax: 16384, mLeftCurVal: 8000, mRightCurVal: 8000)
    ]
    
    
    private let ITEM_LENGTH = 26
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }

    override func encode() {
        super.encode()
        writeInt8(mMode)
        writeInt8(0)//预留
        writeArray(mAncModeList)
    }

    override func decode() {
        super.decode()
        mMode = Int(readInt8())
        _ = readInt8()
        mAncModeList = readArray(3, BleAncMode.ITEM_LENGTH)
    }
    
    init(mMode: Int, mAncModeList: [BleAncMode]) {
        super.init()
        self.mMode = mMode
        self.mAncModeList = mAncModeList
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mMode = try container.decode(Int.self, forKey: .mMode)
        mAncModeList = try container.decode([BleAncMode].self, forKey: .mAncModeList)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mMode, forKey: .mMode)
        try container.encode(mAncModeList, forKey: .mAncModeList)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mMode, mAncModeList
    }
    
    open override var description: String {
        return "BleEarphoneAncSettings(mMode=\(mMode), mAncModeList=\(mAncModeList))"
    }
}
