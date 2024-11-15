//
//  BleSosCallLog.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/7/16.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleSosCallLog: BleReadable {
    
    public var mTime: Int = 0     //拨打时间,距离当地2000/1/1 00:00:00的秒数
    public var mDuration: Int = 0     //通话持续时间
    public var mType: Int = 0    //通话类型,0:拔打,1:来电
    public var mPhone: String = ""     //来电号码
    public var mLastHrTime: Int = 0  //最近一次心率记录的时间
    public var mLastBOTime: Int = 0  //最近一次血氧的时间
    public var mBpm: Int = 0  //心率值
    public var mBOValue: Int = 0  //血氧值
    
    
    private static let PHONE_LENGTH = 24
    public static let ITEM_LENGTH = 48
    
    override func decode() {
        super.decode()
        
        mTime = Int(readUInt32(ByteOrder.LITTLE_ENDIAN))
        mDuration = Int(readInt16(ByteOrder.LITTLE_ENDIAN))
        mType = Int(readUInt16(ByteOrder.LITTLE_ENDIAN))
        mPhone = readString(BleSosCallLog.PHONE_LENGTH)
        mLastHrTime = Int(readUInt32(ByteOrder.LITTLE_ENDIAN))
        mLastBOTime = Int(readUInt32(ByteOrder.LITTLE_ENDIAN))
        mBpm = Int(readUInt8())
        mBOValue = Int(readUInt8())
    }
    
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mTime = try container.decode(Int.self, forKey: .mTime)
        mDuration = try container.decode(Int.self, forKey: .mDuration)
        mType = try container.decode(Int.self, forKey: .mType)
        mPhone = try container.decode(String.self, forKey: .mPhone)
        mLastHrTime = try container.decode(Int.self, forKey: .mLastHrTime)
        mLastBOTime = try container.decode(Int.self, forKey: .mLastBOTime)
        mBpm = try container.decode(Int.self, forKey: .mBpm)
        mBOValue = try container.decode(Int.self, forKey: .mBOValue)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mTime, forKey: .mTime)
        try container.encode(mDuration, forKey: .mDuration)
        try container.encode(mType, forKey: .mType)
        try container.encode(mPhone, forKey: .mPhone)
        try container.encode(mLastHrTime, forKey: .mLastHrTime)
        try container.encode(mLastBOTime, forKey: .mLastBOTime)
        try container.encode(mBpm, forKey: .mBpm)
        try container.encode(mBOValue, forKey: .mBOValue)
    }

    private enum CodingKeys: String, CodingKey {
        case mTime, mDuration, mType, mPhone, mLastHrTime, mLastBOTime, mBpm, mBOValue
    }
    
    open override var description: String {
        return "BleSosCallLog(mTime=\(mTime), mDuration=\(mDuration), mPhone:\(mPhone), mLastHrTime:\(mLastHrTime), mLastBOTime:\(mLastBOTime), mBpm:\(mBpm), mBOValue:\(mBOValue))"
    }
}
