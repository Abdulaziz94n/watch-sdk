//
//  BleBrandInfo.swift
//  SmartWatchCodingBleKit
//
//  Created by Coding on 2023/9/13.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

/**
 * Header
 */
private class BleBrandInfoHeader: BleWritable {
    public var mFileTypeFlag: String = "BR" //文件类型标记, Ascii字符"BR"
    public var mItemCount: Int = 0//元素个数
    public var mFileSize: Int = 0//文件长度
    public var mCRC: Int = 0 //CRC校验和
    
    
    static let ITEM_LENGTH = 2 + 1 + 1 + 4 + 2 + 22
    override var mLengthToWrite: Int {
        return BleBrandInfoHeader.ITEM_LENGTH
    }

    override func encode() {
        super.encode()
        writeStringWithFix(mFileTypeFlag, 2, .ascii)  // 2
        writeInt8(mItemCount)  //
        writeInt8(0)
        writeInt32(mFileSize)
        writeInt16(mCRC)
        writeData(Data(count: 22))
    }
}


/**
 * Item0：BLE名称，元素固定长度128，名称实际可用长度126（除去Length和末尾的0）
 */
private class BleBrandInfoItem0: BleWritable {
    public var mBleName: String = "" //蓝牙名
    
    private static let NAME_LENGTH = 126
    static let ITEM_LENGTH = BleBrandInfoItem0.NAME_LENGTH + 2
    override var mLengthToWrite: Int {
        return BleBrandInfoItem0.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeInt8(min(mBleName.count, BleBrandInfoItem0.NAME_LENGTH) + 1)//名称长度，包括末尾的0
        writeStringWithFix(mBleName, BleBrandInfoItem0.NAME_LENGTH, .ascii)
        writeInt8(0)//补0
    }
}

/**
 * Item1：图片
 */
private class BleBrandInfoItem1: BleWritable {
    
    public var mX: Int = 0 //绘制时x坐标
    public var mY: Int = 0 //绘制时y坐标
    public var mAnchor: Int = 0 //绘制时xy对齐
    public var mCount: Int = 0 //图片数量
    public var mPlayInterval: Int = 0 //播放间隔
    public var mImageInfos = [BleBrandInfoImage]() //图片信息 * Count
    public var mImageBuffers = [Data]() //图片流 * Count

    static let ITEM_HEADER_LENGTH = 4 + 4 + 1 + 1 + 2 + 20
    override var mLengthToWrite: Int {
        BleBrandInfoItem1.ITEM_HEADER_LENGTH + mImageInfos.count * BleBrandInfoImage.ITEM_LENGTH + getImageBufferSize()
    }
    
    /**
     * 图片流的总长度
     */
    private func getImageBufferSize() -> Int {
        var size = 0;
        for it in mImageBuffers {
            size += it.count
        }
        return size
    }

    override func encode() {
        super.encode()
        writeInt32(mX, ByteOrder.LITTLE_ENDIAN)
        writeInt32(mY, ByteOrder.LITTLE_ENDIAN)
        writeInt8(mAnchor)
        writeInt8(mCount)
        writeInt16(mPlayInterval, ByteOrder.LITTLE_ENDIAN)
        writeData(Data(count: 20))  // 0B0 行
        
        
        for it in mImageInfos {
            writeObject(it)
        }
        for it in mImageBuffers {
            writeData(it)
        }
    }
}

/**
 * 品牌包图片信息
 */
private class BleBrandInfoImage: BleWritable {
    
    public var mId: Int = 0 //图片个数
    public var mAddress: Int = 0 //图片流相对地址
    public var mWidth: Int = 0 //宽度
    public var mHeight: Int = 0 //高度
    public var hasAlpha: Int = 0 //是否有透明通道
    public var mCompression: Int = 0 //压缩方式
    public var mPixelFormat: Int = 0 //像素格式

    static let ITEM_LENGTH = 4 + 4 + 2 + 2 + 1 + 3
    override var mLengthToWrite: Int {
        BleBrandInfoImage.ITEM_LENGTH
    }

    override func encode() {
        super.encode()
        // 0C 0D
        writeInt32(mId, ByteOrder.LITTLE_ENDIAN)
        writeInt32(mAddress, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mWidth, ByteOrder.LITTLE_ENDIAN)
        writeInt16(mHeight, ByteOrder.LITTLE_ENDIAN)
        writeIntN(0, 2)
        writeIntN(hasAlpha, 1)
        writeIntN(mCompression, 2)
        writeIntN(mPixelFormat, 3)
        writeInt24(0)
    }
}

/**
 * 品牌包
 */
private class BleBrandInfo: BleWritable {
    
    public var mHeader: BleBrandInfoHeader = BleBrandInfoHeader() //头部
    public var mItem0: BleBrandInfoItem0 = BleBrandInfoItem0() //Item0：BLE名称
    public var mItem1: BleBrandInfoItem1 = BleBrandInfoItem1() //Item1：开机图片

    override var mLengthToWrite: Int{
        BleBrandInfoHeader.ITEM_LENGTH + 4 * 2 + BleBrandInfoItem0.ITEM_LENGTH + mItem1.mLengthToWrite
    }
    
    
    override func encode() {
        super.encode()
        var addressOffset = 0
        writeObject(mHeader)
        addressOffset += (BleBrandInfoHeader.ITEM_LENGTH + 4 * 2)
        writeInt32(addressOffset, ByteOrder.LITTLE_ENDIAN)
        addressOffset += BleBrandInfoItem0.ITEM_LENGTH
        writeInt32(addressOffset, ByteOrder.LITTLE_ENDIAN)
        writeObject(mItem0)
        writeObject(mItem1)
    }
}

/**
 * 品牌包图片
 */
public struct BrandInfoImageItem {
    
    public var mX: Int = 0 //绘制时x坐标
    public var mY: Int = 0 //绘制时y坐标
    public var mAnchor: Int = 0 //绘制时xy对齐
    public var mPlayInterval: Int = 0 //播放间隔
    public var mImageInfos = [BrandInfoImage]() //图片信息 * Count
    
    public init() {}
    public init(mX: Int, mY: Int, mAnchor: Int, mPlayInterval: Int, mImageInfos: [BrandInfoImage] = [BrandInfoImage]()) {
        self.mX = mX
        self.mY = mY
        self.mAnchor = mAnchor
        self.mPlayInterval = mPlayInterval
        self.mImageInfos = mImageInfos
    }
}

/**
 * 品牌包图片信息
 */

public enum CdBitmapCompression: Int {
    
    case CD_BITMAP_COMPRESSION_NONE = 0
    // RLE分行逐像素压缩, 每张图片的前面部分为每行压缩后的长度和偏移地址
    case CD_BITMAP_COMPRESSION_RLE_LINE = 1
    // 杰理压缩格式
    case CD_BITMAP_COMPRESSION_JL = 2
    // jpg格式，但是按照JL要求，图标宽高必须16对齐，暂不支持语言包使用
    case CD_BITMAP_COMPRESSION_JL_JPEG = 3
}


public struct BrandInfoImage {
    public var mWidth: Int = 0 //宽度
    public var mHeight: Int = 0 //高度
    // 杰里支持2D使用2, 杰里支持不支持2D使用1 其他建议使用1
    public var mCompression: CdBitmapCompression = .CD_BITMAP_COMPRESSION_RLE_LINE
    public var mPixelFormat: Int = 0 //像素格式
    public var mImageBuffer = Data() //图片流
    public var hasAlpha: Int = 0 //是否有透明通道
    
    public init() {}
    public init(mWidth: Int, mHeight: Int, mCompression: CdBitmapCompression, mPixelFormat: Int, mImageBuffer: Data = Data(), hasAlpha: Int) {
        self.mWidth = mWidth
        self.mHeight = mHeight
        self.mCompression = mCompression
        self.mPixelFormat = mPixelFormat
        self.mImageBuffer = mImageBuffer
        self.hasAlpha = hasAlpha
    }
}

open class BrandInfoBuilder {
    
    // 固件目前使用的是这个CD_RGB_565, APP也保持一致统一即可
    public static let CD_RGB_565 = 0x01     // R(5)G(6)B(5)小端序
    public static let CD_RGB_565_BE = 0x02  // R(5)G(6)B(5)大端序
    public static let CD_RGB_888 = 0x02     // R(8)G(8)B(8)
    
    public static let GRAVITY_X_LEFT = 1
    public static let GRAVITY_X_RIGHT = 1 << 1
    public static let GRAVITY_X_CENTER = 1 << 2
    public static let GRAVITY_Y_TOP = 1 << 3
    public static let GRAVITY_Y_BOTTOM = 1 << 4
    public static let GRAVITY_Y_CENTER = 1 << 5

    /// 注意, 目前校验和还没有处理
    public class func build(bleName: String, item: BrandInfoImageItem) -> Data {
        
        var addressOffset = 0
        
        let brandInfo = BleBrandInfo()
        //头部
        brandInfo.mHeader.mItemCount = 2//目前是两个item
        addressOffset += brandInfo.mHeader.mLengthToWrite
        
        //元素地址映射表
        addressOffset += 4 * brandInfo.mHeader.mItemCount

            //蓝牙名
        brandInfo.mItem0.mBleName = bleName
        addressOffset += brandInfo.mItem0.mLengthToWrite

            //图片
        brandInfo.mItem1.mX = item.mX
        brandInfo.mItem1.mY = item.mY
        brandInfo.mItem1.mAnchor = item.mAnchor
        brandInfo.mItem1.mCount = item.mImageInfos.count
        brandInfo.mItem1.mPlayInterval = item.mPlayInterval
        addressOffset += BleBrandInfoItem1.ITEM_HEADER_LENGTH//图片参数的长度

            //图片信息
        addressOffset += (brandInfo.mItem1.mCount * BleBrandInfoImage.ITEM_LENGTH)//开机图片信息的长度
        
        var imageBuffers = [Data]()
        var imageInfos = [BleBrandInfoImage]()
        
        for it in item.mImageInfos  {
            
            imageBuffers.append(it.mImageBuffer)
            
            let infoImg = BleBrandInfoImage()
            infoImg.mId = 0xFFFFFFFF
            infoImg.mAddress = addressOffset
            infoImg.mWidth = it.mWidth
            infoImg.mHeight = it.mHeight
            infoImg.hasAlpha = it.hasAlpha
            infoImg.mCompression = it.mCompression.rawValue
            infoImg.mPixelFormat = it.mPixelFormat
            
            imageInfos.append(infoImg)
            
            addressOffset = addressOffset + it.mImageBuffer.count
        }
        brandInfo.mItem1.mImageInfos = imageInfos
        brandInfo.mItem1.mImageBuffers = imageBuffers
                
        return brandInfo.toData()
    }
}
