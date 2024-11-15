//
//  BleDoubleScreenSettings.swift
//  SmartV3
//
//  Created by SMA-IOS on 2023/9/21.
//  Copyright © 2023 CodingIOT. All rights reserved.
//
//
// Created by Best Mafen on 2019/9/30.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleDoubleScreenSettings: BleWritable {
    static let ITEM_LENGTH = 16

    override var mLengthToWrite: Int {
        BleNoDisturbSettings.ITEM_LENGTH
    }
    /**
     mEnabled -> off or open
     mBleTimeRange1、2、3 function activation time
     *** Note **
     the device is restricted by hardware, currently only mBleTimeRange1 can be used to turn on or off the function
     *** Note **
     */
    public var mEnabled: Int = 0
    public var mBleTimeRange1 = BleTimeRange()
    public var mBleTimeRange2 = BleTimeRange()
    public var mBleTimeRange3 = BleTimeRange()

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()
        writeInt8(mEnabled)
        writeObject(mBleTimeRange1)
        writeObject(mBleTimeRange2)
        writeObject(mBleTimeRange3)
    }

    override func decode() {
        super.decode()
        mEnabled = Int(readUInt8())
        mBleTimeRange1 = readObject(BleTimeRange.ITEM_LENGTH)
        mBleTimeRange2 = readObject(BleTimeRange.ITEM_LENGTH)
        mBleTimeRange3 = readObject(BleTimeRange.ITEM_LENGTH)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mBleTimeRange1 = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange1)
        mBleTimeRange2 = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange2)
        mBleTimeRange3 = try container.decode(BleTimeRange.self, forKey: .mBleTimeRange3)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mBleTimeRange1, forKey: .mBleTimeRange1)
        try container.encode(mBleTimeRange2, forKey: .mBleTimeRange2)
        try container.encode(mBleTimeRange3, forKey: .mBleTimeRange3)
    }

    private enum CodingKeys: String, CodingKey {
        case mEnabled, mBleTimeRange1, mBleTimeRange2, mBleTimeRange3
    }

    open override var description: String {
        "BleDoubleScreenSettings(mEnabled: \(mEnabled), mBleTimeRange1: \(mBleTimeRange1)"
            + ", mBleTimeRange2: \(mBleTimeRange2), mBleTimeRange3: \(mBleTimeRange3))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = [
            "mEnabled":mEnabled,
            "mBleTimeRange1":mBleTimeRange1.toDictionary(),
            "mBleTimeRange2":mBleTimeRange2.toDictionary(),
            "mBleTimeRange3":mBleTimeRange3.toDictionary()
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleNoDisturbSettings{
        let newModel = BleNoDisturbSettings()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mEnabled = dic["mEnabled"] as? Int ?? 0
        let dic1 : [String:Any] = dic["mBleTimeRange1"] as? [String:Any] ?? [:]
        let dic2 : [String:Any] = dic["mBleTimeRange2"] as? [String:Any] ?? [:]
        let dic3 : [String:Any] = dic["mBleTimeRange3"] as? [String:Any] ?? [:]
        newModel.mBleTimeRange1 = BleTimeRange().dictionaryToObjct(dic1)
        newModel.mBleTimeRange2 = BleTimeRange().dictionaryToObjct(dic2)
        newModel.mBleTimeRange3 = BleTimeRange().dictionaryToObjct(dic3)
        return newModel
    }
}
