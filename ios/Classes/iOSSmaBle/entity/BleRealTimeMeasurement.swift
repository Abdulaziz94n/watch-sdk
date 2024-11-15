//
//  BleRealTimeMeasurement.swift
//  SmartV3
//
//  Created by SMA-IOS on 2022/8/25.
//  Copyright © 2022 KingHuang. All rights reserved.
//

import Foundation

/// APP控制设备进入心率，血压，血氧，压力测量模式
open class BleRealTimeMeasurement: BleWritable {
    static let ITEM_LENGTH = 1
    override var mLengthToWrite: Int {
        BleRealTimeMeasurement.ITEM_LENGTH
    }
    
    @objc public var mHRSwitch: Int = 0 //心率 HR  0->off 1->open
    @objc public var mBOSwitch: Int = 0 //血氧 BloodOxygen
    @objc public var mBPSwitch: Int = 0 //血压 Blood Pressure
    @objc public var mStressSwitch: Int = 0 //压力 Stress
    /// 测量状态, 0：测量成功/结果，1：测量停止/失败，2：测试开始
    @objc public var mState: Int = 0
    
    override func encode() {
        super.encode()
        writeIntN(mState, 2)
        writeIntN(0, 2)
        writeIntN(mStressSwitch,1)
        writeIntN(mBPSwitch,1)
        writeIntN(mBOSwitch,1)
        writeIntN(mHRSwitch,1)
    }
    
    override func decode() {
        super.decode()
        mState = Int(readUIntN(2))
        _ = readUIntN(2)
        mStressSwitch = Int(readUIntN(1))
        mBPSwitch = Int(readUIntN(1))        
        mBOSwitch = Int(readUIntN(1))
        mHRSwitch = Int(readUIntN(1))
    }
    
    open override var description: String {
        "BleRealTimeMeasurement(mState:\(mState) mHRSwitch: \(mHRSwitch), mBOSwitch: \(mBOSwitch), mBPSwitch: \(mBPSwitch), mStressSwitch: \(mStressSwitch))"
    }
}
