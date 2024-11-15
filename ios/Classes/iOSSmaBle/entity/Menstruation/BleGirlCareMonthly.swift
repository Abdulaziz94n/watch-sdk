//
//  BleGirlCareMonthly.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/6/14.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

enum BleGirlCareMonthlyType: Int {
    /// 普通
    case DEFAULT = 0
    /// 生理期开始日
    case MENSTRUATION_START = 1
    /// 经期
    case MENSTRUATION = 2
    /// 生理期结束日
    case MENSTRUATION_END = 3
    /// 易孕期
    case EASY_PREGNANCY = 4
    /// 排卵日
    case OVULATION_DATE = 5
}

/// 生理期月报
open class BleGirlCareMonthly: BleReadable {

    @objc public var mList = [Int]()
    
    override func decode() {
        super.decode()
        if let safeData = mData, !safeData.isEmpty {
            for it in safeData {
                mList.append(Int(it))
            }
        }
    }
    
    open override var description: String {
        "BleGirlCareMonthly(mSize:\(mList.count), mList:\(mList))"
    }
}
