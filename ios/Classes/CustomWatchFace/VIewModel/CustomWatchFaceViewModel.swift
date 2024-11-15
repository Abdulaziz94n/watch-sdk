//
//  CustomWatchFaceViewModel.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/2/14.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

class CustomWatchFaceViewModel {
    
    private let dateFormat1 : DateFormatter = {
        let dateF = DateFormatter()
        //当前国家编号
        let code = ((Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode)) as! String
        let idenCode = "en" + "_" + code
        //设置locale，防止有些语言filename转换成乱码  统一设置成en_国家编号
        dateF.locale = Locale.init(identifier: idenCode)
        return dateF
    }()

    /// 字节对齐, 默认4字节对齐, 有更好的方法, 后续再优化
    func byteAlignment(_ data: Data, _ num: Int = 4) -> Data {
        
        
        // 字节对齐, 还是有其他的解决方法, 我这里暂时这样 首先开辟一块内存空间 byteCount: 当前总的字节大小
        var newByte = data
        var isOk = !(newByte.count  % 4 == 0)
        //print("测试数据, 是否4字节对齐:\(!isOk) 余数:\(newByte.count % 4)")
        
        while isOk {
            
            newByte.append(Data(int8: 0))
            isOk = !(newByte.count % 4 == 0)
            //print("测试数据, 是否4字节对齐:\(!isOk) 余数:\(newByte.count % 4)")
        }
        
        return newByte
    }
    
    
    private func getImagePathToData(imagePath: String, ofType:String)-> Data{

        var newData :Data = Data()
        if ofType.elementsEqual("bmp"){
            //bmp图片特殊处理方式
            let newImage = UIImage(contentsOfFile: imagePath)//用于计算图片宽度
            let bmpWidth: Int = Int(newImage!.size.width)  //图片宽度
            let bitCount: Int = 16 //位深度，可为8，16，24，32
            let isReverseRows  = false  //是否反转行数据，就是将第一行置换为最后一行
            let rowSize: Int = (bitCount * bmpWidth + 31) / 32 * 4
            var offset = 0
            if !(bmpWidth % 2 == 0){
                offset = 2;
            }
            var image16 = NSData.init(contentsOfFile: imagePath)! as Data
            //删除BMP头部信息
            let headerInfoSize: Int = Int(image16[10]) //头部信息长度
            for _ in 0..<headerInfoSize{
                image16.remove(at: 0)
            }
            //判断单、双数，单数要减去无用字节
            let dataCount :Int = image16.count/rowSize
            let tmpNewData :NSMutableArray = NSMutableArray()
            let imageByte : [UInt8] = [UInt8] (image16)
            for index in 0..<dataCount{
                //截取每一行数据
                var tmpData :Data = Data()
                for rowIndex in 0..<(rowSize - offset) {
                    tmpData.append(imageByte[index * rowSize + rowIndex])
                }
                tmpNewData.add(tmpData)
            }
            //将获得的行数据反转
            image16.removeAll()
            for index in 0..<tmpNewData.count {
                var dataIndex = index
                if !isReverseRows {//需要反转则重置下标
                    dataIndex = tmpNewData.count-1-index
                }
                let data : Data = tmpNewData.object(at:dataIndex) as! Data
                image16.append(data)
            }
            //小端序修改为大端序
            var index = 0
            newData.removeAll()
            while index<image16.count{
                let item1 = image16[index]
                let item2 = image16[index+1]
                newData.append(item2)
                newData.append(item1)
                index += 2
            }
            return newData
        }else{
            let newImage = UIImage(contentsOfFile: imagePath)
            newData = newImage!.pngData()!
        }
        return newData
    }
}


//MARK: - 主要创建表盘元素
extension CustomWatchFaceViewModel {
    
    func getPreviewImages(pvModel: ABHElementConverModel, bgImage: UIImage, converModels: [ABHElementConverModel]) -> UIImage? {
        
        // 创建子控件模型
        var controlModels = [ABHControlModel]()
        for it in converModels {
        
            if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_PREVIEW ||
                it.type == WatchFaceBuilder.sharedInstance.ELEMENT_BACKGROUND {
                // 预览图, 背景元素不用处理
                continue
            } else if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_HOUR {
                // 小时, 需要准备2个
                guard let zeroImgPath = it.imagePaths.first else {
                    bleLog("pv ELEMENT_DIGITAL_HOUR it.imagePaths.first not found. it:\(it)")
                    continue
                }
                guard let zeroImage = UIImage(contentsOfFile: zeroImgPath) else {
                    bleLog("pv ELEMENT_DIGITAL_HOUR Image path firstImgPath failed to be created zeroImgPath:\(zeroImgPath)")
                    continue
                }
                
                controlModels.append(ABHControlModel(type: it.type, x: it.x, y: it.y, image: zeroImage))
                
                if it.imagePaths.count > 8 {
                    let eightImgPath = it.imagePaths[8]
                    guard let eightImage = UIImage(contentsOfFile: eightImgPath) else {
                        bleLog("pv ELEMENT_DIGITAL_HOUR Image path subImgPath failed to be created eightImgPath:\(eightImgPath)")
                        continue
                    }
                    controlModels.append(ABHControlModel(type: it.type, x: it.x + it.w, y: it.y, image: eightImage))
                } else {
                    bleLog("Warning: ELEMENT_DIGITAL_HOUR The number of hours preview resources is not greater than 8, so do not add the number 8 to the preview")
                }
            } else if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_MIN {
                // 分钟, 需要准备2个
                if it.imagePaths.count > 3 {
                    let threeImgPath = it.imagePaths[3]
                    guard let threeImage = UIImage(contentsOfFile: threeImgPath) else {
                        bleLog("pv ELEMENT_DIGITAL_MIN Image path threeImgPath failed to be created threeImgPath:\(threeImgPath)")
                        continue
                    }
                    controlModels.append(ABHControlModel(type: it.type, x: it.x, y: it.y, image: threeImage))
                } else {
                    bleLog("Warning: ELEMENT_DIGITAL_MIN The number of minute preview resources is not greater than 3, so the number 3 is not added to the preview.")
                }
                
                guard let zeroImgPath = it.imagePaths.first else {
                    bleLog("pv ELEMENT_DIGITAL_MIN it.imagePaths.first not found. it:\(it)")
                    continue
                }
                guard let zeroImage = UIImage(contentsOfFile: zeroImgPath) else {
                    bleLog("pv ELEMENT_DIGITAL_MIN Image path firstImgPath failed to be created zeroImgPath:\(zeroImgPath)")
                    continue
                }
                controlModels.append(ABHControlModel(type: it.type, x: it.x + it.w, y: it.y, image: zeroImage))
                
            } else if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_MONTH {
                // 月份, 需要准备2个
                guard let zeroImgPath = it.imagePaths.first else {
                    bleLog("pv ELEMENT_DIGITAL_MONTH it.imagePaths.first not found. it:\(it)")
                    continue
                }
                guard let zeroImage = UIImage(contentsOfFile: zeroImgPath) else {
                    bleLog("pv ELEMENT_DIGITAL_MONTH Image path firstImgPath failed to be created zeroImgPath:\(zeroImgPath)")
                    continue
                }
                
                controlModels.append(ABHControlModel(type: it.type, x: it.x, y: it.y, image: zeroImage))
                
                if it.imagePaths.count > 7 {
                    let augustImgPath = it.imagePaths[7]
                    guard let augustImage = UIImage(contentsOfFile: augustImgPath) else {
                        bleLog("pv ELEMENT_DIGITAL_MONTH Image path subImgPath failed to be created augustImgPath:\(augustImgPath)")
                        continue
                    }
                    controlModels.append(ABHControlModel(type: it.type, x: it.x + it.w, y: it.y, image: augustImage))
                } else {
                    bleLog("Warning: ELEMENT_DIGITAL_MONTH The number of monthly preview resources is not greater than 7, so the number 7 is not added to the preview.")
                }
            } else if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_DAY {
                // 月份, 需要准备2个
                guard let zeroImgPath = it.imagePaths.first else {
                    bleLog("pv ELEMENT_DIGITAL_DAY it.imagePaths.first not found. it:\(it)")
                    continue
                }
                guard let zeroImage = UIImage(contentsOfFile: zeroImgPath) else {
                    bleLog("pv ELEMENT_DIGITAL_DAY Image path firstImgPath failed to be created zeroImgPath:\(zeroImgPath)")
                    continue
                }
                
                controlModels.append(ABHControlModel(type: it.type, x: it.x, y: it.y, image: zeroImage))
                
                if it.imagePaths.count > 8 {
                    let augustImgPath = it.imagePaths[8]
                    guard let augustImage = UIImage(contentsOfFile: augustImgPath) else {
                        bleLog("pv ELEMENT_DIGITAL_DAY Image path subImgPath failed to be created augustImgPath:\(augustImgPath)")
                        continue
                    }
                    controlModels.append(ABHControlModel(type: it.type, x: it.x + it.w, y: it.y, image: augustImage))
                } else {
                    bleLog("Warning: ELEMENT_DIGITAL_DAY The number of monthly preview resources is not greater than 8, so the number 8 is not added to the preview.")
                }
            } else if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_AMPM ||
                        it.type == WatchFaceBuilder.sharedInstance.ELEMENT_DIGITAL_WEEKDAY {
                
                guard let subImgPath = it.imagePaths.first else {
                    bleLog("pv type:\(it.type) it.imagePaths.first not found. it:\(it)")
                    continue
                }
                guard let bgImage = UIImage(contentsOfFile: subImgPath) else {
                    bleLog("pv type:\(it.type) Image path subImgPath failed to be created subImgPath:\(subImgPath)")
                    continue
                }
                
                controlModels.append(ABHControlModel(type: it.type, x: it.x, y: it.y, image: bgImage))
            }
        }
        
        let pvSize = CGSize(width: pvModel.w, height: pvModel.h)
        // 子控件模型为空, 直接返回背景图片
        if controlModels.isEmpty {
            bleLog("The preview image control is empty and returns directly to the preview image.")
            return bgImage.scaled(to: pvSize)
        }
        
        let pvImage = compositePreviewImages(bgImage: bgImage, images: controlModels)
        return pvImage?.scaled(to: pvSize)
    }
    
    private func compositePreviewImages(bgImage: UIImage, images: [ABHControlModel]) -> UIImage? {
        
        var compositeImage: UIImage?
        
        // Get the size of the first image.  This function assume all images are same size
        let size: CGSize = CGSize(width: bgImage.size.width, height: bgImage.size.height)
        UIGraphicsBeginImageContext(size)
        bgImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        for it in images {
            let rect = CGRect(x: CGFloat(it.x), y: CGFloat(it.y), width: it.image.size.width, height: it.image.size.height)
            if it.type == WatchFaceBuilder.sharedInstance.ELEMENT_NEEDLE_HOUR {
                //let angle = CGFloat.pi / 2.0
                var angle: CGFloat { return 30 * 180 / .pi }
                let tr = CGAffineTransform.identity.rotated(by: angle)
                if let ciImage = it.image.ciImage?.transformed(by: tr) {
                    UIImage(ciImage: ciImage).draw(in: rect)
                }
            } else {
                it.image.draw(in: rect)
            }
        }
        
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compositeImage
    }
    
    
    
    public func getBackgroundImages(bgModel: ABHElementConverModel, subControls: [ABHElementConverModel]) -> UIImage? {
        
        guard let imgPath = bgModel.imagePaths.first else {
            bleLog("bgModel.imagePaths.first not found. bgModel:\(bgModel)")
            return nil
        }
        guard let bgImage = UIImage(contentsOfFile: imgPath) else {
            bleLog("Image path imgPath failed to be created correctly:\(imgPath)")
            return nil
        }
        
        // 创建子控件模型
        var controlModels = [ABHControlModel]()
        for it in subControls {
            
            guard let subImgPath = it.imagePaths.first else {
                bleLog("it.imagePaths.first not found. it:\(it)")
                continue
            }
            guard let bgImage = UIImage(contentsOfFile: subImgPath) else {
                bleLog("Image path subImgPath failed to be created subImgPath:\(subImgPath)")
                continue
            }
            
            controlModels.append(ABHControlModel(type: 0, x: it.x, y: it.y, image: bgImage))
        }
        
        // 子控件模型为空, 直接返回背景图片
        if controlModels.isEmpty {
            bleLog("The other controls in the background are empty and return directly to the background view.")
            return bgImage
        }
        
        return compositeBgImages(bgImage: bgImage, images: controlModels)
    }
    
    private func compositeBgImages(bgImage: UIImage, images: [ABHControlModel]) -> UIImage? {
        
        var compositeImage: UIImage?
        
        // Get the size of the first image.  This function assume all images are same size
        let size: CGSize = CGSize(width: bgImage.size.width, height: bgImage.size.height)
        UIGraphicsBeginImageContext(size)
        bgImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        for it in images {
            let rect = CGRect(x: CGFloat(it.x), y: CGFloat(it.y), width: it.image.size.width, height: it.image.size.height)
            it.image.draw(in: rect)
        }
        
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compositeImage
    }
    

    public func saveImage(image: UIImage?, name: String = "", suffix: String) {
        
        var fileName = ""
        if name.isEmpty {
            dateFormat1.dateFormat = "YYYYMMddHHmm-ss"
            fileName = dateFormat1.string(from: Date())
        } else {
            fileName = name
        }
        
        fileName += suffix
        do{
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let opusURL = URL(fileURLWithPath: documentPath + "/" + fileName)
            try image?.pngData()?.write(to: opusURL, options: .atomic)
            bleLog("\(fileName)图片保存, 执行成功")
        }catch {
            bleLog("图片保存执行失败, error:\(error)")
        }
    }
}


extension UIImage {
    
    /// 重新排列像素点
    /// - Parameter heightDivisor: 如果指针元素, 就可以使用0.6, 如果是其他元素, 就必须传递为1.0
    /// - Parameter heightDivisor: If it is a pointer element, you can use 0.6, if it is another element, you must pass it as 1.0
    func rearrangePixels(_ heightDivisor: CGFloat = 0.6) -> (pixData:Data?, width:Int, height:Int) {
        
        let h = Int(self.size.height * heightDivisor)
        let w = Int(self.size.width)
        // A R G B
        // 转换图片  17 * 3
        let rowSize = Int((w * 3 + 4 - 1) / 4 * 4)
        var newData = Data(repeating: UInt8(0), count: rowSize * h)
        
        
        guard let pixArray = self.extraPixels(in: self.size) else {
            return (nil, 0, 0)
        }
        //print("测试pixArray:\(String(describing: pixArray))")
        //print("")
        
        for y in 0..<h {
            
            var rowBytes = Data(repeating: UInt8(0), count: rowSize)
            for x in 0..<w {
                
                let index = y * w + x
                let a565 = argb8888To8565(pixArray[index])
                
                let offset = x * 3
                rowBytes[offset + 2] = UInt8(a565 & 0xFF)
                rowBytes[offset + 1] = UInt8((a565 >> 8) & 0xFF)
                rowBytes[offset + 0] = UInt8((a565 >> 16) & 0xFF)  // a
            }
            
            newData.insert(contentsOf: rowBytes, at: y * rowSize)
        }
        
        return (newData, w, h)
    }
    
    private func argb8888To8565(_ pixel: UInt32) -> UInt32 {
        
        // iOS这边是RGBA 和安卓的ARGB不一样, 获取像素点的颜色, 需要单独处理
        let r = CGFloat((pixel >> 0)  & 0xff) / 255.0
        let g = CGFloat((pixel >> 8)  & 0xff) / 255.0
        let b = CGFloat((pixel >> 16) & 0xff) / 255.0
        let a = CGFloat((pixel >> 24) & 0xff) / 255.0
        //print("r : \(r), g : \(g), b : \(b), a : \(a)")
        
        let multiplier = CGFloat(255.999999)
        let rawR = UInt32(Int(r * multiplier))
        let rawG = UInt32(Int(g * multiplier))
        let rawB = UInt32(Int(b * multiplier))
        let rawA = UInt32(Int(a * multiplier))
        
        let f = (rawR >> 3)
        return (rawA << 16) + (f << 11) + ((rawG >> 2) << 5) + (rawB >> 3)
    }
    // 旧的参考安卓的方法, 不要使用, 仅作为一个参考即可
    //private func argb8888To8565_2(argb: UInt32) -> UInt32 {
    //
    //    // iOS这边是RGBA 和安卓的ARGB不一样, 获取像素点的颜色, 需要单独处理
    //    let r = argb >> 24 & 0xFF
    //    let g = argb >> 16 & 0xFF
    //    let b = argb >> 8 & 0xFF
    //    let a = argb & 0xFF
    //
    //
    //    let f = (r >> 3)
    //    return (a << 16) + (f << 11) + ((g >> 2) << 5) + (b >> 3)
    //}
    
    /// 字节对齐, 默认4字节对齐, 有更好的方法, 后续再优化
    private func byteAlignment(_ data: Data, _ num: Int = 4) -> Data {
        
        
        // 字节对齐, 还是有其他的解决方法, 我这里暂时这样 首先开辟一块内存空间 byteCount: 当前总的字节大小
        var newByte = data
        var isOk = !(newByte.count  % 4 == 0)
        //print("测试数据, 是否4字节对齐:\(!isOk) 余数:\(newByte.count % 4)")
        
        while isOk {
            
            newByte.append(Data(int8: 0))
            isOk = !(newByte.count % 4 == 0)
            //print("测试数据, 是否4字节对齐:\(!isOk) 余数:\(newByte.count % 4)")
        }
        
        return newByte
    }
    
    /// 根据图片大小提取像素
    ///
    /// - parameter size: 图片大小
    ///
    /// - returns: 像素数组
    private func extraPixels(in size: CGSize) -> [UInt32]? {
        
        guard let cgImg = self.cgImage else {
            return nil
        }
        /*
         不能直接以image的宽高作为绘制的宽高，因为image的size可能会比控件的size大很多。
         所以在生成bitmapContext的时候需要以实际的控件宽高为准
         */
        let w = Int(size.width)
        let h = Int(size.height)
        let bitsPerComponent = 8 // 32位的图像，所以每个颜色组件包含8bit
        let bytesPerRow = w * 4  // 1 byte = 8 bit, 32位图像的话，每个像素包含4个byte
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue // RGBA
        // let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        // 因为是32位图像，RGBA各占8位 8*4=32，所以像素数据的数组的元素类型应该是UInt32。
        var bufferData = Array<UInt32>(repeating: 0, count: w * h)
        guard let cxt = CGContext(data: &bufferData, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        // 将图像绘制进上下文中
        //cxt.draw(cgImg, in: rect)
        cxt.draw(cgImg, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return bufferData
    }
}

/**
 test code
 
 //let fontSize: CGFloat = 12.0
 //let fontColor = UIColor.white
 //
 //
 //// 计算文字所占的size，文字居中显示在画布上
 //let attributes = [
 //    NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
 //    NSAttributedString.Key.foregroundColor: UIColor .white,
 //]
 //
 ///// 文字写入, 2023-09-16新增加
 //func textLayer2(text:String, fontSize:CGFloat = 12) -> CATextLayer {
 //
 //    let layer = CATextLayer()
 //    layer.string = text
 //    layer.font = UIFont.systemFont(ofSize: fontSize)
 //    layer.fontSize = fontSize
 //    //layer.foregroundColor = color.cgColor
 //    layer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: layer.preferredFrameSize())
 //    layer.alignmentMode = .left
 //    layer.isWrapped = true
 //    layer.contentsScale = UIScreen.main.scale;
 //    return layer
 //}
 //
 //let title = "2589"
 //
 //let obj = textLayer2(text: title)
 ////print(obj.frame)
 //
 //(title as NSString).draw(at: CGPoint(x: 50, y: 50), withAttributes: attributes)
 //
 
 */
