//
//  BleQrcode2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/8/9.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleQrcode2: BleWritable {

    @objc public var mId: Int = 0
    @objc public var mTitle: String = ""
    public var mWidth: Int = 0
    @objc public var mQRData = Data()
    
    private let TITLE_LENGTH = 30
    static let ITEM_LENGTH = 512
    override var mLengthToWrite: Int {
        BleQrcode2.ITEM_LENGTH
    }
    
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mId = try container.decode(Int.self, forKey: .mId)
        mTitle = try container.decode(String.self, forKey: .mTitle)
        mWidth = try container.decode(Int.self, forKey: .mWidth)
        mQRData = try container.decode(Data.self, forKey: .mQRData)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mId, forKey: .mId)
        try container.encode(mTitle, forKey: .mTitle)
        try container.encode(mWidth, forKey: .mWidth)
        try container.encode(mQRData, forKey: .mQRData)
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case mId, mTitle, mWidth, mQRData
    }
    
    override func encode() {
        super.encode()
        writeInt8(mId)
        writeStringWithFix(mTitle, self.TITLE_LENGTH)
        writeInt8(mWidth)
        writeData(mQRData)
    }
    
    open override var description: String {
        "BleQrcode2(mId:\(mId), mTitle:\(mTitle), mWidth:\(mWidth), mQRData:\(mQRData.count))"
    }
}
