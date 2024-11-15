//
//  BleSOSSettings.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/7/31.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

open class BleSOSSettings: BleWritable {
    
    /// SOS开关, 0:关闭;  1:开启
    @objc public var mEnabled: Int = 0
    /// 电话号码
    @objc public var mPhone: String = ""

    private let PHONE_MAX_LENGTH = 18
    override var mLengthToWrite: Int {
        return PHONE_MAX_LENGTH + 2
    }
    
    
    override func encode() {
        super.encode()
        
        writeInt8(mEnabled)
        writeInt8(mPhone.count)
        writeStringWithFix(mPhone, PHONE_MAX_LENGTH)
    }
    
    override func decode() {
        super.decode()
        
        mEnabled = Int(readInt8())
        let phoneLength = Int(readInt8())
        mPhone = readString(phoneLength)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mEnabled = try container.decode(Int.self, forKey: .mEnabled)
        mPhone = try container.decode(String.self, forKey: .mPhone)
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mEnabled, forKey: .mEnabled)
        try container.encode(mPhone, forKey: .mPhone)
    }

    private enum CodingKeys: String, CodingKey {
        case mEnabled, mPhone
    }
    
    open override var description: String {
        return "BleSOSSettings(mEnabled=\(mEnabled), mPhone=\(mPhone))"
    }
}
