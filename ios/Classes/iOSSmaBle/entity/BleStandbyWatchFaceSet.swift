//
//  BleStandbyWatchFaceSet.swift
//  SmartV3
//
//  Created by Coding on 2023/10/11.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleStandbyWatchFaceSet: BleWritable {

    static let ITEM_LENGTH = 8

    override var mLengthToWrite: Int {
        BleStandbyWatchFaceSet.ITEM_LENGTH
    }
    
    /// 待机使能
    public var mStandbyEnable = 0
    /// 总开关
    public var mEnabled: Int = 1
    public var mBleTimeRange1 = BleTimeRange()
    public var mReserved = 1 // 预留, 默认1, 设备返回什么就重新发给设备什么, 不用赋值

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()
        writeInt8(mStandbyEnable)
        writeInt8(mEnabled)
        writeObject(mBleTimeRange1)
        writeInt8(mReserved)
    }

    override func decode() {
        super.decode()
        mStandbyEnable = Int(readUInt8())
        mEnabled = Int(readUInt8())
        mBleTimeRange1 = readObject(BleTimeRange.ITEM_LENGTH)
        mReserved = Int(readInt8())
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mStandbyEnable = try container.decode(Int.self, forKey: .mStandbyEnable)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mBleTimeRange1 = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange1)
        mReserved = try container.decode(Int.self, forKey: .mReserved)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mStandbyEnable, forKey: .mStandbyEnable)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mBleTimeRange1, forKey: .mBleTimeRange1)
        try container.encode(mReserved, forKey: .mReserved)
    }

    private enum CodingKeys: String, CodingKey {
        case mStandbyEnable, mEnabled, mBleTimeRange1, mReserved
    }

    open override var description: String {
        "BleNoDisturbSettings(mStandbyEnable:\(mStandbyEnable), mEnabled:\(mEnabled), mBleTimeRange1:\(mBleTimeRange1), mReserved:\(mReserved)"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = [
            "mStandbyEnable":mStandbyEnable,
            "mEnabled":mEnabled,
            "mBleTimeRange1":mBleTimeRange1.toDictionary(),
            "mReserved": mReserved
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleStandbyWatchFaceSet {
        let newModel = BleStandbyWatchFaceSet()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mStandbyEnable = dic["mStandbyEnable"] as? Int ?? 0
        newModel.mEnabled = dic["mEnabled"] as? Int ?? 0
        let dic1 : [String:Any] = dic["mBleTimeRange1"] as? [String:Any] ?? [:]
        newModel.mBleTimeRange1 = BleTimeRange().dictionaryToObjct(dic1)
        newModel.mReserved = dic["mReserved"] as? Int ?? 0
        return newModel
    }
}
