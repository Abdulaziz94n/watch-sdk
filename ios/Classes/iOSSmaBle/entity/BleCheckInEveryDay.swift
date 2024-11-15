//
//  BleCheckInEveryDay.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/7/16.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleCheckInEveryDay: BleWritable {

    public var mStartHour: Int = 0 //打卡时间段时
    public var mStartMinute: Int = 0//打卡时间段分
    public var mEndHour: Int = 0//打卡结束时间段时
    public var mEndMinute: Int = 0//打卡结束时间段分
    public var mStepRanking: Int = 0//步数排名
    public var mEarnPoints: Int = 0//获得积分
    public var mCheckTime: Int = 0//打卡时间, 距离当地2000/1/1 00:00:00的秒数
    public var mStatus: Int = 0//打卡状态
    
    public static let ITEM_LENGTH = 16
    override var mLengthToWrite: Int {
        return BleCheckInEveryDay.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mStartHour)
        writeInt8(mStartMinute)
        writeInt8(mEndHour)
        writeInt8(mEndMinute)
        writeInt16(mStepRanking, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mEarnPoints, ByteOrder.LITTLE_ENDIAN)
        writeInt32(mCheckTime, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mStatus)
        writeInt24(0)
    }
    
    override func decode() {
        super.decode()
        mStartHour = Int(readInt8())
        mStartMinute = Int(readInt8())
        mEndHour = Int(readInt8())
        mEndMinute = Int(readInt8())
        mStepRanking = Int(readInt16(ByteOrder.LITTLE_ENDIAN))
        mEarnPoints = Int(readInt16(ByteOrder.LITTLE_ENDIAN))
        mCheckTime = Int(readInt32(ByteOrder.LITTLE_ENDIAN))
        mStatus = Int(readInt8())
        _ = readInt16()
        _ = readInt8()
    }
    
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mStartHour = try container.decode(Int.self, forKey: .mStartHour)
        mStartMinute = try container.decode(Int.self, forKey: .mStartMinute)
        mEndHour = try container.decode(Int.self, forKey: .mEndHour)
        
        mEndMinute = try container.decode(Int.self, forKey: .mEndMinute)
        mStepRanking = try container.decode(Int.self, forKey: .mStepRanking)
        mEarnPoints = try container.decode(Int.self, forKey: .mEarnPoints)
        
        mStatus = try container.decode(Int.self, forKey: .mStatus)
        mCheckTime = try container.decode(Int.self, forKey: .mCheckTime)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mStartHour, forKey: .mStartHour)
        try container.encode(mStartMinute, forKey: .mStartMinute)
        try container.encode(mEndHour, forKey: .mEndHour)
        
        try container.encode(mEndMinute, forKey: .mEndMinute)
        try container.encode(mStepRanking, forKey: .mStepRanking)
        try container.encode(mEarnPoints, forKey: .mEarnPoints)
        
        try container.encode(mStatus, forKey: .mStatus)
        try container.encode(mCheckTime, forKey: .mCheckTime)
    }

    private enum CodingKeys: String, CodingKey {
        case mStartHour, mStartMinute, mEndHour, mEndMinute, mStepRanking, mEarnPoints, mStatus, mCheckTime
    }
    
    open override var description: String {
        return "BleCheckInEveryDay(mStartHour=\(mStartHour), mStartMinute=\(mStartMinute), mEndHour:\(mEndHour), mEndMinute:\(mEndMinute), mStepRanking:\(mStepRanking), mEarnPoints:\(mEarnPoints), mStatus:\(mStatus), mCheckTime:\(mCheckTime))"
    }
}
