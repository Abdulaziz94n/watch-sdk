//
//  BleActivityDetail.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2023/11/20.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

/// 每小时步数、卡路里、距离存储
open class BleActivityDetail: BleReadable {

    /// 类型
    public var mType = ActivityDetailType.TYPE_STEP
    /// 列表
    public var mList = [Int]()

    public enum ActivityDetailType: UInt {
        /// 步数
        case TYPE_STEP = 0
        /// 卡路里, 单位cal
        case TYPE_CAL
        /// 距离, 单位m
        case TYPE_DISTANCE
    }
    

    override func decode() {
        super.decode()
        mType = ActivityDetailType(rawValue: UInt(readUInt8())) ?? .TYPE_STEP
        _ = readUInt24()

        var tempList = [Int]()
        for _ in 0..<24 {
            tempList.append(Int(readUInt16(.LITTLE_ENDIAN)))
        }
        self.mList = tempList
    }
    
    open override var description: String {
        "BleActivityDetail(mType:\(mType), mList:\(mList))"
    }
}
