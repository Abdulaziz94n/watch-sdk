//
// Created by Best Mafen on 2019/9/30.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleGestureWake2: BleWritable {
    static let ITEM_LENGTH = 8

    override var mLengthToWrite: Int {
        BleGestureWake2.ITEM_LENGTH
    }

    /// 全天使能开关  0 关闭, 1 开启
    public var mEnabled: Int = 0
    public var mBleTimeRange = BleTimeRange()

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()
        writeInt8(mEnabled)
        writeObject(mBleTimeRange)
        writeInt8(0)
        writeInt8(0)
    }

    override func decode() {
        super.decode()
        mEnabled = Int(readInt8())
        mBleTimeRange = readObject(BleTimeRange.ITEM_LENGTH)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mBleTimeRange = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mBleTimeRange, forKey: .mBleTimeRange)
    }

    private enum CodingKeys: String, CodingKey {
        case mEnabled, mBleTimeRange
    }

    open override var description: String {
        "BleGestureWake2(mEnabled:\(mEnabled), mBleTimeRange:\(mBleTimeRange))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mEnabled": mEnabled, "mBleTimeRange":mBleTimeRange.toDictionary() ]
        
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleGestureWake2{
        let newModel = BleGestureWake2()
        if dic.keys.count<1{
            return newModel
        }
        let dic1 : [String:Any] = dic["mBleTimeRange"] as? [String:Any] ?? [:]
        newModel.mEnabled = dic["mEnabled"] as? Int ?? 0
        newModel.mBleTimeRange = BleTimeRange().dictionaryToObjct(dic1)
        return newModel
    }
}
