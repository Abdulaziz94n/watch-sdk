//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

class BleStreamProgress: BleReadable {
    static let ITEM_LENGTH = 9

    // 0: 传输成功
    // 1: 文件类型不支持
    // 2: 文件大小问题, 文件大小超过本地存储的空间
    // 4: 当前状态不支持传输, 例如打电话, 充电, 测量心率....
    // 5: Flash读写错误
    public var mStatus: Int = 0
    public var mErrorCode: Int = 0 // 错误类型，未出错时忽略
    public var mTotal: Int = 0
    public var mCompleted: Int = 0

    override func decode() {
        super.decode()
        mStatus = Int(readUIntN(4))
        mErrorCode = Int(readUIntN(4))
        mTotal = Int(readInt32())
        mCompleted = Int(readInt32())
    }

    override var description: String {
        "BleStreamProgress(mStatus: \(mStatus), mErrorCode: \(mErrorCode), mTotal: \(mTotal), mCompleted: \(mCompleted))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mStatus":mStatus,
                                    "mErrorCode":mErrorCode,
                                    "mTotal":mTotal,
                                    "mCompleted":mCompleted]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleStreamProgress{

        let newModel = BleStreamProgress()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mStatus = dic["mStatus"] as? Int ?? 0
        newModel.mErrorCode = dic["mErrorCode"] as? Int ?? 0
        newModel.mTotal = dic["mTotal"] as? Int ?? 0
        newModel.mCompleted = dic["mCompleted"] as? Int ?? 0
        return newModel
    }
}
