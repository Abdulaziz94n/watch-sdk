//
//  BleAlipayBindInfo.swift
//  SmartWatchCodingBleKit
//
//  Created by 叩鼎科技 on 2023/9/7.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

open class BleAlipayBindInfo: BleReadable {

    static let ITEM_LENGTH = 8

    public var mTime: Int = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mResult: Int = 0 // 绑定的结果, 具体参考 AliPayResultType 取值

    override func decode() {
        super.decode()
        mTime = Int(readInt32())
        mResult = Int(readUInt8())
    }
    
    
    public enum AliPayResultType: Int {
        
        /// 绑定成功
        case SUCCESS = 0
        /// 绑定ble连接失败
        case CONNECT_FAILED
        /// 绑定ble连接成功, 通讯过程失败, 可能是时间不对
        case COMMUNICATE_FAILED
        /// 绑定时ble连接成功，但是超过1分钟没有绑定成功（可能是蓝牙中途断连）
        case COMMUNICATE_TIMEOUT
        /// 未知的失败原因
        case OTHER
    }

    open override var description: String {
        "BleAlipayBindInfo(mTime:\(mTime), mResult:\(mResult))"
    }
}
