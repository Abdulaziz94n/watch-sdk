//
//  BleMatchRecordPlayer.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/4/14.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleMatchRecordPlayer: BleReadable {
    static let NAME_LENGTH = 26

    /// 球员名字utf8编码
    public var mName = ""
    /// 球员号码
    public var mNum = 0
    

    override func decode() {
        super.decode()
        
        mName = readString(BleMatchRecordPlayer.NAME_LENGTH-1)
        mNum = Int(readInt8())
    }
    
    open override var description: String {
        "BleMatchRecordPlayer(mName:\(mName), mNum:\(mNum))"
    }
}
