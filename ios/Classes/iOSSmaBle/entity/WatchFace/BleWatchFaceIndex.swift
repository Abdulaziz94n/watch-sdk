//
//  BleWatchFaceIndex.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2024/6/11.
//  Copyright © 2024 CodingIOT. All rights reserved.
//

import UIKit

public enum BleWatchFaceType: Int {
    /// 内置表盘，不可替换
    case BUILTIN = 0
    /// APP从云端下载后同步至手表的表盘，可替换
    case CLOUDY = 1
    /// APP上用户制作后同步至手表的表盘，可替换
    case CUSTOM = 2
}

/**
 * 某些设备支持多个外置表盘，即手表表盘个数不是通常的x + 1，而是x + y + z，其中：
 * x为BLE_WATCHFACE_TYPE_BUILTIN个数，y为BLE_WATCHFACE_TYPE_CLOUDY个数，z为BLE_WATCHFACE_TYPE_CUSTOM个数。
 * 这个指令用于标记是哪种表盘的第几个表盘。
 * 当BleKeyFlag为BLE_KEY_FLAG_READ时：查询手表当前正在使用的是哪种表盘的第几个表盘
 * 当BleKeyFlag为BLE_KEY_FLAG_CREATE时：APP接下来要发送的表盘是哪种表盘的第几个表盘（type不会是BLE_WATCHFACE_TYPE_BUILTIN）
 * 当BleKeyFlag为BLE_KEY_FLAG_UPDATE时：APP命令切换至的表盘是哪种表盘的第几个表盘
 */
open class BleWatchFaceIndex: BleWritable {
    
    /// 表盘类型, 参考BleWatchFaceType枚举值
    @objc public var mType: Int = 0
    /// 表盘索引
    @objc public var mIndex: Int = 0
    
    override var mLengthToWrite: Int {
        return 2
    }
    
    override func encode() {
        super.encode()
        writeInt8(mType)
        writeInt8(mIndex)
    }
    
    override func decode() {
        super.decode()
        mType = Int(readUInt8())
        mIndex = Int(readUInt8())
    }
    
    open override var description: String {
        "BleWatchFaceIndex(mType:\(mType), mIndex:\(mIndex))"
    }
}
