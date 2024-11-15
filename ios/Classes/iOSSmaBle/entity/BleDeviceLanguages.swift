//
//  BleDeviceLanguages.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/8/1.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

open class BleDeviceLanguages: BleReadable {

    /// 当前语言id
    public var mCode = 0
    /// 支持语言的总数量
    public var mSize = 0
    /// 语言列表, 具体对应关系参考Languages 类文件
    public var mList = [Int]()
    
    override func decode() {
        super.decode()
        
        mCode = Int(readInt8())
        _ = readData(4) // 预留
        mSize = Int(readInt8())
        for _ in 0..<mSize {
            mList.append(Int(readInt8()))
        }
    }
    
    open override var description: String {
        return "BleDeviceLanguages(mCode:\(String(format: "0x%02X", mCode))mSize=\(mSize), mList=\(mList))"
    }
}
