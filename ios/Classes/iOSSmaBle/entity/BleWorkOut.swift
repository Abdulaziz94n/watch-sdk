//
//  BleWorkOut.swift
//  SmartV3
//
//  Created by SMA on 2020/5/25.
//  Copyright © 2020 KingHuang. All rights reserved.
//

import Foundation
//汇总式的锻炼数据
open class BleWorkOut:  BleReadable{
    static let ITEM_LENGTH = 48

    public var mStart = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mEnd   = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mDuration  = 0 // 运动持续时长，数据以秒为单位
    public var mAltitude  = 0 // 海拔高度，数据以米为单位
    public var mAirPressure = 0 // 气压，数据以 kPa 为单位
    public var mSpm = 0  //步频，步数/分钟的值，直接可用
    public var mMode = 0 //运动类型，与 BleActivity 中的 mMode 定义一致
    public var mStep = 0      //步数，与 BleActivity 中的 mStep 定义一致
    public var mDistance = 0 //米，以米为单位，例如接收到的数据为56045，则代表 56045 米 约等于 56.045 Km
    public var mCalorie = 0 //卡，以卡为单位，例如接收到的数据为56045，则代表 56.045 Kcal 约等于 56 Kcal
    public var mSpeed = 0    //速度，接收到的数据以 米/小时 为单位
    public var mPace = 0  //配速，接收到的数据以 秒/千米 为单位
    public var mAvgBpm = 0  //平均心率
    public var mMaxBpm = 0  //最大心率
    // 预留位不写
    

    override func decode() {
        super.decode()
        mStart    = Int(readInt32())
        mEnd      = Int(readInt32())
        mDuration    = Int(readUInt16())
        mAltitude    = Int(readInt16())
        mAirPressure = Int(readUInt16())
        mSpm         = Int(readUInt8())
        mMode        = Int(readUInt8())
        mStep        = Int(readInt32())
        mDistance    = Int(readInt32())
        mCalorie     = Int(readInt32())
        mSpeed       = Int(readInt32())
        mPace        = Int(readInt32())
        mAvgBpm      = Int(readUInt8())
        mMaxBpm      = Int(readUInt8())
    }

    open override var description: String {
        "BleWorkOut(mStart: \(mStart), mEnd: \(mEnd), mDuration: \(mDuration)," +
            " mAltitude: \(mAltitude), mAirPressure: \(mAirPressure), mSpm: \(mSpm), mMode: \(mMode)," +
            " mStep: \(mStep), mDistance: \(mDistance), mCalorie: \(mCalorie), mSpeed: \(mSpeed)," +
            " mPace: \(mPace), mAvgBpm: \(mAvgBpm), mMaxBpm: \(mMaxBpm))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mStart":mStart,
                                    "mEnd":mEnd,
                                    "mDuration":mDuration,
                                    "mAltitude":mAltitude,
                                    "mSpm":mSpm,
                                    "mMode":mMode,
                                    "mStep":mStep,
                                    "mDistance":mDistance,
                                    "mCalorie":mCalorie,
                                    "mSpeed":mSpeed,
                                    "mPace":mPace,
                                    "mAvgBpm":mAvgBpm,
                                    "mMaxBpm":mMaxBpm]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleWorkOut{

        let newModel = BleWorkOut()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mStart = dic["mStart"] as? Int ?? 0
        newModel.mEnd = dic["mEnd"] as? Int ?? 0
        newModel.mDuration = dic["mDuration"] as? Int ?? 0
        newModel.mAltitude = dic["mAltitude"] as? Int ?? 0
        newModel.mSpm = dic["mSpm"] as? Int ?? 0
        newModel.mMode = dic["mMode"] as? Int ?? 0
        newModel.mDistance = dic["mDistance"] as? Int ?? 0
        newModel.mCalorie = dic["mCalorie"] as? Int ?? 0
        newModel.mSpeed = dic["mSpeed"] as? Int ?? 0
        newModel.mPace = dic["mPace"] as? Int ?? 0
        newModel.mAvgBpm = dic["mAvgBpm"] as? Int ?? 0
        newModel.mMaxBpm = dic["mMaxBpm"] as? Int ?? 0
        return newModel
    }
}
