//
//  BleEarphonePower.swift
//  SmartV3
//
//  Created by Coding on 2024/2/23.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

open class BleEarphonePower: BleWritable {

    public var mLeftPower: Int = 0
    public var mRightPower: Int = 0
    
    private let ITEM_LENGTH = 2
    override var mLengthToWrite: Int {
        return ITEM_LENGTH
    }
    
    
    override func encode() {
        super.encode()
        writeInt8(mLeftPower)
        writeInt8(mRightPower)
    }

    override func decode() {
        super.decode()
        mLeftPower = Int(readInt8())
        mRightPower = Int(readInt8())
    }
    
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mLeftPower = try container.decode(Int.self, forKey: .mLeftPower)
        mRightPower = try container.decode(Int.self, forKey: .mRightPower)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mLeftPower, forKey: .mLeftPower)
        try container.encode(mRightPower, forKey: .mRightPower)
    }
    
    private enum CodingKeys: String, CodingKey {
        case mLeftPower, mRightPower
    }
    
    open override var description: String {
        return "BleEarphonePower(mLeftPower=\(mLeftPower), mRightPower=\(mRightPower))"
    }
}
