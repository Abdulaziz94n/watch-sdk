//
//  BleDeviceSportData.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/8/10.
//  Copyright © 2023 szabh. All rights reserved.
//

import Foundation

open class BleDeviceSportData: BleReadable {
    
    static let ITEM_LENGTH = 64

    /// 运动时长, 单位: 秒
    public var mDuration = 0
    /// 当前心率
    public var mBpm = 0
    /// 步频, 步数每分钟
    public var mSpm  = 0
    /// 步数
    public var mStep = 0
    /// 运动距离, 以米为单位
    public var mDistance = 0
    /// 卡路里, 以千卡单位  1kal
    public var mCalorie = 0
    /// 速度，单位：米每小时
    public var mSpeed = 0
    /// 配速 单位：秒每公里
    public var mPace = 0
    /// 当前海拔 单位：m
    public var mAltitude = 0
    /// 上升海拔 单位: 米
    public var mRiseAltitude = 0
    /// 运动模式 与 BleActivity 中的 mMode 定义一致
    public var mMode = 0

    
    override func decode() {
        super.decode()
        mDuration = Int(readUInt16(.LITTLE_ENDIAN))
        mBpm = Int(readUInt8())
        mSpm = Int(readUInt8())
        mStep = Int(readInt32(.LITTLE_ENDIAN))
        mDistance = Int(readInt32(.LITTLE_ENDIAN))
        mCalorie = Int(readInt32(.LITTLE_ENDIAN))
        mSpeed = Int(readInt32(.LITTLE_ENDIAN))
        mPace = Int(readInt32(.LITTLE_ENDIAN))
        mAltitude = Int(readInt16(.LITTLE_ENDIAN))
        mRiseAltitude = Int(readInt16(.LITTLE_ENDIAN))
        mMode = Int(readUInt8())
    }

    open override var description: String {
        "BleDeviceSportData(mDuration:\(mDuration), mBpm:\(mBpm), mSpm:\(mSpm), mStep:\(mStep), " +
        "mDistance:\(mDistance), mCalorie:\(mCalorie), mSpeed:\(mSpeed), mPace:\(mPace), mAltitude:\(mAltitude) " +
        "mRiseAltitude:\(mRiseAltitude), mMode:\(mMode)" +
        ")"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = [
            "mDuration":mDuration,
            "mBpm":mBpm,
            "mSpm":mSpm,
            "mSpeed":mSpeed,
            "mDistance":mDistance,
            "mCalorie":mCalorie,
            "mStep":mStep,
            "mPace":mPace,
            "mAltitude":mAltitude,
            "mRiseAltitude":mRiseAltitude,
            "mMode":mMode,
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleDeviceSportData {
        
        let newModel = BleDeviceSportData()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mDuration = dic["mDuration"] as? Int ?? 0
        newModel.mBpm = dic["mBpm"] as? Int ?? 0
        newModel.mSpm = dic["mSpm"] as? Int ?? 0
        newModel.mSpeed = dic["mSpeed"] as? Int ?? 0
        newModel.mDistance = dic["mDistance"] as? Int ?? 0
        newModel.mCalorie = dic["mCalorie"] as? Int ?? 0
        newModel.mStep = dic["mStep"] as? Int ?? 0
        newModel.mPace = dic["mPace"] as? Int ?? 0
        newModel.mAltitude = dic["mAltitude"] as? Int ?? 0
        newModel.mRiseAltitude = dic["mRiseAltitude"] as? Int ?? 0
        newModel.mMode = dic["mMode"] as? Int ?? 0
        
        return newModel
    }
}
