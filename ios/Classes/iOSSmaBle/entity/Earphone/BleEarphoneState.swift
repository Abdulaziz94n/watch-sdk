//
//  BleEarphoneState.swift
//  SmartV3
//
//  Created by Coding on 2024/3/6.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleEarphoneState: BleReadable {

    public var mLeftState: Int = 0 //左耳状态
    public var mRightState: Int = 0 //右耳状态
    
    
    override func decode() {
        super.decode()
        mLeftState = Int(readInt8())
        mRightState = Int(readInt8())
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mLeftState = try container.decode(Int.self, forKey: .mLeftState)
        mRightState = try container.decode(Int.self, forKey: .mRightState)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mLeftState, forKey: .mLeftState)
        try container.encode(mRightState, forKey: .mRightState)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mLeftState, mRightState
    }
    
    open override var description: String {
        return "BleEarphoneState(mLeftState=\(mLeftState), mRightState=\(mRightState))"
    }
}

public enum BleEarphoneStateType: Int {
    /// 在耳机仓中
    case STATE_CHARGING = 0
    /// 连接耳机仓
    case STATE_CHARGE_CONNECTED = 0x01
    /// 耳机连接手机
    case STATE_PHONE_CONNECTED = 0x02
    /// 耳机关机状态
    case STATE_SHUTDOWN = 0x03
}

