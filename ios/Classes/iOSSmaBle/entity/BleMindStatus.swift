//
//  BleFeelingData.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/12/27.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

/// 心情数据
open class BleMindStatus: BleReadable {

    /// 距离当地2000/1/1 00:00:00 的秒数
    public var mTime: Int = 0
    /// 评分
    public var mValue: Int = 0
    
    static let ITEM_LENGTH = 6
    
    override func decode() {
        super.decode()
        
        mTime = Int(readInt32())
        mValue = Int(readInt8())
    }
    
    open override var description: String {
        "BleMindStatus(mTime:\(mTime), mValue:\(mValue))"
    }
}
