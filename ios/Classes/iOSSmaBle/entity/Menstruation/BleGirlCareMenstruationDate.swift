//
//  BleGirlCareMenstruationDate.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/6/14.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleGirlCareMenstruationDate: BleWritable {

    /// 0: 开始,  1: 结束
    public var mType = 0
    ///
    public var mTime = BleTime()
    
    private static let ITEM_LENGTH = 1 + BleTime.ITEM_LENGTH
    override var mLengthToWrite: Int {
        return BleGirlCareMenstruationDate.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mType)
        writeObject(mTime)
    }
    
    override func decode() {
        super.decode()
        mType = Int(readInt8())
        mTime = readObject(BleTime.ITEM_LENGTH)
    }
    
    open override var description: String {
        return "BleGirlCareMenstruationDate(mType:\(mType), mTime:\(mTime))"
    }
}
