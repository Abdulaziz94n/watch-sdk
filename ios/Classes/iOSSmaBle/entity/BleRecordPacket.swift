//
//  BleRecordPacket.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/7/18.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleRecordPacket: BleReadable {
    
    public var mYear: Int = 0
    public var mMonth: Int = 0
    public var mDay: Int = 0
    public var mHour: Int = 0
    public var mMinute: Int = 0
    public var mSecond: Int = 0
    public var mLength: Int = 0
    public var mStatus: Int = 0
    public var mMode: Int = 0
    public var mPacket = Data()
    
    override func decode() {
        super.decode()
        
        mYear = Int(readUInt8()) + 2000
        mMonth = Int(readUInt8())
        mDay = Int(readUInt8())
        mHour = Int(readUInt8())
        mMinute = Int(readUInt8())
        mSecond = Int(readUInt8())
        mLength = Int(readUInt16(ByteOrder.LITTLE_ENDIAN))
        mStatus = Int(readUInt8())
        mMode = Int(readUInt8())
        let _ = readData(22)//保留
        mPacket = readData(mLength)
    }
    
    /// 传输语言的类型
    public enum VoiceModel: Int {
        /// 普通的
        case NORMAL = 0
        /// AI表盘
        case AI_WATCHFACE = 1
    }
    
    /// 传输状态
    public enum TransferStatus: Int {
        /// 开始
        case start = 0
        /// 继续
        case go_On = 1
        /// 结束
        case end = 2
        /// 暂停
        case suspend = 3
    }
    
    open override var description: String {
        "BleRecordPacket(mYear:\(mYear), mMonth:\(mMonth), mDay:\(mDay), mHour:\(mHour), mMinute:\(mMinute)" +
        ", mSecond:\(mSecond), mLength:\(mLength), mStatus:\(mStatus), mMode:\(mMode), mPacket:\(mPacket.count))"
    }
}
