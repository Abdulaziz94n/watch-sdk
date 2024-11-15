//
//  BlePressure.swift
//  SmartV3
//
//  Created by SMA on 2021/6/9.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BlePressure: BleReadable {
    static let ITEM_LENGTH = 6

    public var mTime: Int = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mPressure: Int = 0

    override func decode() {
        super.decode()
        mTime = Int(readInt32())
        mPressure = Int(readUInt8())
    }

    open override var description: String {
        "BlePressure(mTime: \(mTime), mPressure: \(mPressure))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mTime":mTime,
                                    "mPressure":mPressure]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BlePressure{

        let newModel = BlePressure()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mPressure = dic["mPressure"] as? Int ?? 0
        return newModel
    }
}
