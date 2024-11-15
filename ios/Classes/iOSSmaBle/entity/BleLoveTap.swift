//
//  BleLoveTap.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2022/11/30.
//  Copyright © 2022 CodingIOT. All rights reserved.
//

import UIKit

open class BleLoveTap: BleWritable {

    public static let ACTION_DOWN = 0x01
    public static let ACTION_UP = 0x02
    
    
    public var mTime: Int = 0
    public var mId: Int = 0
    public var mActionType: Int = 0
    
    private let ITEM_LENGTH = 10
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        
        writeInt(mTime, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mId)
        writeInt8(mActionType)
    }
    
    override func decode() {
        super.decode()
        
        mTime = Int(readUInt64(ByteOrder.LITTLE_ENDIAN))
        mId = Int(readUInt8())
        mActionType = Int(readUInt8())
    }
    
    open override var description: String {
        "BleLoveTap(mTime: \(mTime), mId: \(mId), mActionType: \(mActionType))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic: [String : Any] = [
            "mTime": mTime,
            "mId": mId,
            "mActionType": mActionType
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleLoveTap{

        let newModel = BleLoveTap()
        if dic.keys.isEmpty {
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mId = dic["mId"] as? Int ?? 0
        newModel.mActionType = dic["mActionType"] as? Int ?? 0
        return newModel
    }
}
