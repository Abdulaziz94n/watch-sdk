//
//  BleSosContact.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/6/11.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleSosItem: BleWritable {
    
    @objc public var mEnabled: Int = 0 //开关
    @objc public var mPhone: String = "" //手机号
    @objc public var mName: String = "" //名字
    
    
    private static let PHONE_LENGTH = 18
    private static let NAME_LENGTH = 24
    public static let ITEM_LENGTH = BleSosItem.PHONE_LENGTH + BleSosItem.NAME_LENGTH + 4
    
    override var mLengthToWrite: Int {
        return BleSosItem.ITEM_LENGTH
    }
    
    
    override func encode() {
        super.encode()
        writeInt8(mEnabled)
        writeInt8(0) //保留
        writeInt8(mPhone.count)
        writeStringWithFix(mPhone, BleSosItem.PHONE_LENGTH)
        writeInt8(mName.count)
        writeStringWithFix(mName, BleSosItem.NAME_LENGTH)
    }
    
    override func decode() {
        super.decode()
        mEnabled = Int(readInt8())
        _ = readInt8() //保留
        _ = readInt8() //长度
        mPhone = readString(BleSosItem.PHONE_LENGTH)
        _ = readInt8() //长度
        mName = readString(BleSosItem.NAME_LENGTH)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mPhone = try container.decode(String.self, forKey: .mPhone)
        mName = try container.decode(String.self, forKey: .mName)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mPhone, forKey: .mPhone)
        try container.encode(mName, forKey: .mName)
    }

    private enum CodingKeys: String, CodingKey {
        case mEnabled, mPhone, mName
    }
    
    open override var description: String {
        return "BleSosItem(mEnabled=\(mEnabled), mPhone=\(mPhone), mName:\(mName))"
    }
}

open class BleSosContact: BleWritable {
    /// 总开关
    public var mEnabled: Int = 0
    /// 最大五个
    @objc public var mList = [BleSosItem]()
    
    
    public static let ITEM_LENGTH = BleSosItem.ITEM_LENGTH * 5 + 2
    override var mLengthToWrite: Int {
        return BleSosContact.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mEnabled)
        writeInt8(0)//保留
        writeArray(mList)
    }
    
    override func decode() {
        super.decode()
        mEnabled = Int(readInt8())
        _ = readInt8()
        mList = readArray(5, BleSosItem.ITEM_LENGTH)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mList = try container.decode([BleSosItem].self, forKey: .mList)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mList, forKey: .mList)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mEnabled, mList
    }
    
    open override var description: String {
        return "BleSosContact(mEnabled=\(mEnabled), mList=\(mList))"
    }
}
