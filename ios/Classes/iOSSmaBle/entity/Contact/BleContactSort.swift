//
//  BleContactSort.swift
//  SmartV3
//
//  Created by Coding on 2024/5/17.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

public enum BleContactSortType: Int {
    /// 不排序
    case TYPE_0 = 0
    /// 排序
    case TYPE_1
}

/// 联系人排序设置
open class BleContactSort: BleWritable {

    /// 排序方式，0-不排序；1-排序，如按照A-Z，#的方式排序
    public var mSortType: Int = 0
    public var mSortItems = [BleContactSortItem]()
    
    override var mLengthToWrite: Int {
        return 8 + mSortItems.count * BleContactSortItem.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(mSortType)
        writeData(Data(count: 7))
        //需要将数量转换成偏移
        var list = [BleContactSortItem]()
        var index = 0
        for it in self.mSortItems {
            
            let tempModel = BleContactSortItem()
            tempModel.mCat = it.mCat
            tempModel.mSize = index
            list.append(tempModel)
            index += it.mSize
        }
        writeArray(list)
    }
}

