//
//  BleMatchLog.swift
//  SmartV3
//
//  Created by SMA-IOS on 2021/11/19.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BleMatchLog :BleReadable{
    static let ITEM_LENGTH = 8
    
    public var mTime :Int = 0 //time unit->s 加上比赛开始时间得到完整的时间
    public var mPeriodTime :Int = 0
    public var mPeriodNumber :Int = 0
    public var mType :Int = 0
    public var mCount : Int = 0
    public var mCancelType :Int = 0
    
    override func decode() {
        super.decode()
        mTime = Int(readUInt16(.LITTLE_ENDIAN))
        mPeriodTime = Int(readUInt16(.LITTLE_ENDIAN))
        mPeriodNumber = Int(readUInt8())
        mType = Int(readUInt8())
        mCount = Int(readUInt8())
        mCancelType = Int(readUInt8())        
    }
    
    open override var description: String {
        "BleMatchLog(mTime: \(mTime), mPeriodTime: \(mPeriodTime), mPeriodNumber: \(mPeriodNumber)," +
            " mType: \(mType), mCount: \(mCount), mCancelType: \(mCancelType))"
    }
}
