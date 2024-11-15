//
// Created by Best Mafen on 2019/9/30.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleGestureWake: BleWritable {
    static let ITEM_LENGTH = 5

    override var mLengthToWrite: Int {
        BleGestureWake.ITEM_LENGTH
    }

    @objc public var mBleTimeRange = BleTimeRange()

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    public init(_ timeRange: BleTimeRange) {
        super.init()
        mBleTimeRange = timeRange
    }

    override func encode() {
        super.encode()
        writeObject(mBleTimeRange)
    }

    override func decode() {
        super.decode()
        mBleTimeRange = readObject(BleTimeRange.ITEM_LENGTH)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mBleTimeRange = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mBleTimeRange, forKey: .mBleTimeRange)
    }

    private enum CodingKeys: String, CodingKey {
        case mBleTimeRange
    }

    open override var description: String {
        "BleGestureWake(mBleTimeRange: \(mBleTimeRange))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mBleTimeRange":mBleTimeRange.toDictionary() ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleGestureWake{
        let newModel = BleGestureWake()
        if dic.keys.count<1{
            return newModel
        }
        let dic1 : [String:Any] = dic["mBleTimeRange"] as? [String:Any] ?? [:]
        newModel.mBleTimeRange = BleTimeRange().dictionaryToObjct(dic1)
        return newModel
    }
}
