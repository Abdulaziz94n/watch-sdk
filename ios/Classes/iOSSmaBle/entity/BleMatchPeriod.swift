//
//  BleMatchPeriod.swift
//  SmartV3
//
//  Created by SMA-IOS on 2021/11/19.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BleMatchPeriod :BleReadable{
    static let ITEM_LENGTH = 12
    
    public var mDuration :Int = 0
    public var mDistance :Int = 0
    public var mStep :Int = 0
    public var mCalorie :Int = 0
    public var mSpeed : Int = 0
    public var mAvgBpm :Int = 0
    public var mMaxBpm :Int = 0
    public var mAltitude :Int = 0
    public var mMaxAltitude :Int = 0
    
    
    
    override func decode() {
        super.decode()
        mDuration = Int(readUInt16(.LITTLE_ENDIAN))
        mDistance = Int(readUInt16(.LITTLE_ENDIAN))
        mStep = Int(readUInt16(.LITTLE_ENDIAN))
        mCalorie = Int(readUInt16(.LITTLE_ENDIAN))
        mSpeed = Int(readUInt16(.LITTLE_ENDIAN))
        mAvgBpm = Int(readUInt8())
        mMaxBpm = Int(readUInt8())
        mAltitude = Int(readUInt8())
        mMaxAltitude = Int(readUInt8())
    }
    
    open override var description: String {
        "BleMatchPeriod(mDuration: \(mDuration), mDistance: \(mDistance), mStep: \(mStep)," +
            " mCalorie: \(mCalorie), mSpeed: \(mSpeed), mAvgBpm: \(mAvgBpm), mMaxBpm: \(mMaxBpm)), mAltitude:\(mAltitude),mMaxAltitude:\(mMaxAltitude)"
    }
}
