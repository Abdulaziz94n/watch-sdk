//
//  BleBACResultSettings.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/2/10.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

/// 酒精含量测试结果提示设置
open class BleBACResultSettings: BleWritable {

    public var mLow: Int = 0       //含量低于预设范围
    public var mHigh: Int = 0      //含量高于预设范围
    public var mNormal: Int = 0    //含量在预设范围内
    public var mDuration: Int = 0  //led持续时长, 以秒为单位
    public var mVibrate: Int = 0   //震动提醒强度,1到100
    
    
    public static let LEVE_BLACK = 0x00//黑（灭灯）
    public static let LEVE_RED = 0x01//红
    public static let LEVE_GREEN = 0x02//绿
    public static let LEVE_BLUE = 0x03//蓝
    public static let LEVE_WHITE = 0x04//白
    public static let LEVE_YELLOW = 0x05//黄
    public static let LEVE_PURPLE = 0x06//紫色
    public static let LEVE_CYAN_BLUE = 0x07//青色
    
    private let ITEM_LENGTH = 8
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    
    public init(mLow: Int, mHigh: Int, mNormal: Int, mDuration: Int, mVibrate: Int) {
        super.init()
        
        self.mLow = mLow
        self.mHigh = mHigh
        self.mNormal = mNormal
        self.mDuration = mDuration
        self.mVibrate = mVibrate
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mLow = try container.decode(Int.self, forKey: .mLow)
        mHigh = try container.decode(Int.self, forKey: .mHigh)
        mNormal = try container.decode(Int.self, forKey: .mNormal)
        mDuration = try container.decode(Int.self, forKey: .mDuration)
        mVibrate = try container.decode(Int.self, forKey: .mVibrate)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mLow, forKey: .mLow)
        try container.encode(mHigh, forKey: .mHigh)
        try container.encode(mNormal, forKey: .mNormal)
        
        try container.encode(mDuration, forKey: .mDuration)
        try container.encode(mVibrate, forKey: .mVibrate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mLow, mHigh, mNormal, mDuration, mVibrate
    }
  
    override func encode() {
        super.encode()
        writeInt8(mLow)
        writeInt8(mHigh)
        writeInt8(mNormal)
        writeInt8(mDuration)
        writeInt8(mVibrate)
    }
}
