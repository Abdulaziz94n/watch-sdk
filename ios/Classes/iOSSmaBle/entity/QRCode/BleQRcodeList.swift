//
//  BleQRcodeList.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/8/9.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit


/// 二维码类型
/// bit0: 0表示内容是点阵数据, 1表示内容是字符串
/// bit1-bit7: 标识二维码类型
public enum QRCodeStremType: Int {
    /// 核酸码
    case NUCLEIC_ACID_CODE = 0
    /// 收款码
    case RECEIPT_CODE = 1
    /// 我的名片
    case MY_CARD_CODE = 2
    /// 二维码, 通用的, 不区分收款码和名片
    case QRCODE_CODE = 3
}

open class BleQRcodeList: BleWritable {

    override var mLengthToWrite: Int {
        BleQrcode2.ITEM_LENGTH * qrList.count
    }
    public var qrList: [BleQrcode2] = []
 
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public init(array: [BleQrcode2]) {
        super.init()
        qrList = array
       
    }
    
    /// 为了兼容字符串设置二维码增加的方法
    public func getStreamType(_ isStr: Bool, _ codeType: QRCodeStremType) -> Int {
        if isStr {
            return 0x80 | codeType.rawValue
        } else {
            return codeType.rawValue
        }
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        qrList = try container.decode([BleQrcode2].self, forKey: .qrList)
    }
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(qrList, forKey: .qrList)
    }
    
    private enum CodingKeys: String, CodingKey {
        case qrList
    }
    
    override func encode() {
        super.encode()
        writeArray(qrList)
    }
}
