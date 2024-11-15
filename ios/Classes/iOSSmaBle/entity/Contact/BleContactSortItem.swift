//
//  BleContactSortItem.swift
//  SmartV3
//
//  Created by Coding on 2024/5/17.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

/// 联系人排序设置
open class BleContactSortItem: BleWritable {
    
    public var mCat: String = "" //类别：Unicode（2byte）
    public var mSize: Int = 0 //数量：2byte
    
    static let ITEM_LENGTH = 4
    override var mLengthToWrite: Int {
        return BleContactSortItem.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
//        writeStringWithFix(mCat, 2, .utf16)
        writeStringWithFix(mCat, 2,.utf16LittleEndian)
        writeInt16(mSize, ByteOrder.LITTLE_ENDIAN)
    }
}
