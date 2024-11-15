//
//  BleGirlCarePeriodDate.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/8/18.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

/// 女性生理期周期开始日期
open class BleGirlCarePeriodDate: BleWritable {

    public var mYear: Int = 0
    public var mMonth: Int = 0
    public var mDay: Int = 0
    public var mType: Int = 0 //type类型 0 ：生理期；1 ：排卵期；2 ：安全期

    
    /// 生理期
    public static let TYPE_MENSTRUAL = 0
    /// 排卵期
    public static let TYPE_OVULATION = 1
    /// 安全期
    public static let TYPE_SAFE = 2
    
    static let ITEM_LENGTH = 5
    override var mLengthToWrite: Int {
        return BleGirlCarePeriodDate.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt16(mYear, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mMonth)
        writeInt8(mDay)
        writeInt8(mType)
    }

    override func decode() {
        super.decode()
        mYear = Int(readUInt16(ByteOrder.LITTLE_ENDIAN))
        mMonth = Int(readUInt8())
        mDay = Int(readUInt8())
        mType = Int(readUInt8())
    }
    
    open override var description: String {
        return "BleGirlCarePeriodDate(mYear=\(mYear), mMonth=\(mMonth), mDay=\(mDay), mType=\(mType))"
    }
}

/// 女性生理期周期
/// 生理期 -> 安全期 -> 排卵期 -> 安全期 -> 生理期
open class BleGirlCarePeriod: BleReadable {
    public var mPeriodDateList = [BleGirlCarePeriodDate]()
    
    static let ITEM_LENGTH = 20
    
    override func decode() {
        super.decode()
        mPeriodDateList = readArray(4, BleGirlCarePeriodDate.ITEM_LENGTH)
    }
}

