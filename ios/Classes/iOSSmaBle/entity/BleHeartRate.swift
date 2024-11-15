//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleHeartRate: BleReadable {
    static let ITEM_LENGTH = 6

    public var mTime: Int = 0 // 距离当地2000/1/1 00:00:00的秒数
    @objc public var mBpm: Int = 0

    override func decode() {
        super.decode()
        mTime = Int(readInt32())
        mBpm = Int(readUInt8())
    }

    open override var description: String {
        "BleHeartRate(mTime: \(mTime), mBpm: \(mBpm))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mTime":mTime,
                                    "mBpm":mBpm]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleHeartRate{

        let newModel = BleHeartRate()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mBpm = dic["mBpm"] as? Int ?? 0
        return newModel
    }
}
