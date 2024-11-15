//
//  BleLogText.swift
//  SmartV3
//
//  Created by SMA on 2021/7/24.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

open class BleLogText: BleReadable {
    static let ITEM_LENGTH = 64
    public var mContent :String = ""
    
    override func decode() {
        super.decode()
        
        guard let safeData = mData, !safeData.isEmpty else {
            return
        }
        
        let end = safeData.index(0, offsetBy: 1)
        if end == -1 {
            mContent = String(data: safeData, encoding: .utf8) ?? ""
        }else{
            
            var tempArr = [UInt8]()
            for it in safeData.bytes {
                if it != 0 {
                    tempArr.append(it)
                }
            }
            
            if let safeText = String(bytes: tempArr, encoding: .utf8) {
                mContent = safeText
            } else {
                mContent = String(describing: mData?.mHexString)
            }
        }
    }
    
    
    open override var description: String {
        "BleLogText(mContent:\(mContent))"
    }
    
}
