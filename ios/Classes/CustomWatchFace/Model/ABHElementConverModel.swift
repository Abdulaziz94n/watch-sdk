//
//  ABHElementConverModel.swift
//  sma_coding_dev_flutter_sdk
//
//  Created by Coding on 2023/9/11.
//

import UIKit

class ABHElementConverModel: NSObject {

    /// 元素类型
    var type = 0
    /// 图片是否包含alpha通道, 0-不带alpha；1-带alpha
    var hasAlpha = 0
    
    var w = 0;  //图片宽，必须是2的倍数
    var h = 0;  //图片高
    var gravity = 0; //对齐方式
    var ignoreBlack = 0;//是否忽略黑色，0-不忽略；1-忽略；4-杰里2D加速用
    var x = 0; //anchor确定坐标
    var y = 0; //anchor确定坐标
    var bottomOffset = 0; //指针类型的元素，底部到旋转中心点之间的偏移量
    var leftOffset = 0; //指针类型的元素，左部到旋转中心点之间的偏移量
    var imagePaths = [String]() //图片路径，目前只支持png
    
    init(dic: [String: Any]) {
        
        self.type = dic["type"] as? Int ?? 0
        self.hasAlpha = dic["hasAlpha"] as? Int ?? 0
        
        self.h = dic["h"] as? Int ?? 0
        self.w = dic["w"] as? Int ?? 0
        self.gravity = dic["gravity"] as? Int ?? 0
        self.ignoreBlack = dic["ignoreBlack"] as? Int ?? 0
        self.x = dic["x"] as? Int ?? 0
        self.y = dic["y"] as? Int ?? 0
        
        self.bottomOffset = dic["bottomOffset"] as? Int ?? 0
        self.leftOffset = dic["leftOffset"] as? Int ?? 0
        self.imagePaths = dic["imagePaths"] as? [String] ?? [String]()
    }
    
    
    override var description: String {
        "ABHElementConverModel(type:\(type), hasAlpha:\(hasAlpha), w:\(w), h:\(h), gravity:\(gravity), ignoreBlack:\(ignoreBlack), x:\(x), y:\(y), bottomOffset:\(bottomOffset), leftOffset:\(leftOffset), imagePaths:\(imagePaths))"
    }

}
