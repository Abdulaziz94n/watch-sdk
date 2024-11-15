//
//  BleVoice.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/7/25.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

open class BleVoice: BleWritable {

    public var mCategory: Int = 0
    public var mTime: Int = 0
    public var mContent: String = ""
    public var mStatus: Int = 0//设备暂未实现的字段
    
    
    public static let CATEGORY_INPUT_TEXT = 0x00//输入文本
    public static let CATEGORY_OUTPUT_TEXT = 0x01//输出文本
    /// 内容最大长度，字节数
    public static var CONTENT_MAX_LENGTH: Int {
        get {
            if BleCache.shared.mSupportVoiceMaxLength {
                return (BleCache.shared.mDeviceInfo?.mIOBufferSize ?? 1024) - 9 - 16 // 使用单包最大长度
            } else {
                return 512
            }
        }
    }

    public static let STATUS_DONE = 1
    
    override var mLengthToWrite: Int {
        return 16 + min(mContent.bytes.count, BleVoice.CONTENT_MAX_LENGTH)
    }
    
    override func encode() {
        super.encode()
        writeInt8(mCategory)
        writeData(Data(count: 7))  // 预留字节
        writeObject(BleTime.ofLocal(mTime))
        writeInt16(min(mContent.bytes.count, BleVoice.CONTENT_MAX_LENGTH))
        writeStringWithLimit(mContent, BleVoice.CONTENT_MAX_LENGTH, addEllipsis: true)
    }
    
    open override var description: String {
        "BleAudioText(mCategory=\(mCategory), mTime=\(mTime), mContent=\(mContent), mStatus=\(mStatus))"
    }
}
