//
//  BleMatchRecord.swift
//  SmartV3
//
//  Created by SMA-IOS on 2021/11/19.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BleMatchRecord :BleReadable{
    static let ITEM_LENGTH = 920
    
    public var mStart :Int = 0
    public var mType :Int = 0
    public var mPeriodListSize :Int = 0
    public var mLogListSize :Int = 0
    public var mUndefined : Int = 0  // 保留数据, 1字节
    public var mPeriod :BleMatchPeriod = BleMatchPeriod()
    public var mPeriodArray : [BleMatchPeriod] = []
    public var mLogArray :[BleMatchLog] = []
    
    override func decode() {
        super.decode()
        mStart = Int(readUInt32(.LITTLE_ENDIAN))
        mType = Int(readUInt8())
        mPeriodListSize = Int(readUInt8())
        mLogListSize = Int(readUInt8())
        mUndefined = Int(readUInt8())
        mPeriod = readObject(BleMatchPeriod.ITEM_LENGTH)
        mPeriodArray = readArray(9, BleMatchPeriod.ITEM_LENGTH)
        mLogArray = readArray(mLogListSize, BleMatchLog.ITEM_LENGTH)
    }
    
    open override var description: String {
        "BleMatchRecord(mStart: \(mStart), mType: \(mType), mPeriodListSize: \(mPeriodListSize)," +
            " mLogListSize: \(mLogListSize), mUndefined: \(mUndefined), mPeriod: \(mPeriod), mPeriodList: \(mPeriodArray), mLogList: \(mLogArray))"
    }
}
