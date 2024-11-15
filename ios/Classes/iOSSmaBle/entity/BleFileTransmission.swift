//
//  BleFileTransmission.swift
//  SmartV3
//
//  Created by SMA on 2021/4/27.
//  Copyright © 2021 KingHuang. All rights reserved.
//

import Foundation

public enum FileCompanion : Int {
    case AUDIO = 0, WAV, BIN
    case BMP  // 前4byte是宽和高
}

open class BleFileTransmission: BleReadable {

    static let ITEM_LENGTH = 18
    
    public var mFileType :Int = 0 //0 音频文件
    public var mTime :Int = 0 //时间
    public var mFileIndex :Int = 0 //文件标记,序号最大代表有多少记录
    public var mFileFormat :Int = FileCompanion.AUDIO.rawValue //文件格式 1: wav
    public var mFileSize :Int = 0 //文件大小
    public var mFileOffset :Int = 0 //偏移
    public var mFileData: Data = Data()
    
    override func decode() {
        super.decode()
        mFileType = Int(readInt8())
        mTime = Int(readInt32())
        mFileIndex = Int(readInt32())
        mFileFormat = Int(readInt8())
        mFileSize = Int(readInt32())
        mFileOffset = Int(readInt32())
        if mData!.count>18 {
            mFileData = Data(mData![18..<mData!.count])
        }
        
    }
    
    open override var description: String {
        "BleFileTransmission(mFileType: \(mFileType), mTime: \(mTime), mFileIndex: \(mFileIndex), mFileFormat: \(mFileFormat), mFileSize: \(mFileSize), mFileOffset: \(mFileOffset), mFileData: \(mFileData))"
    }
}
