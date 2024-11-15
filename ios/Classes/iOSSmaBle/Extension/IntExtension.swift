//
//  IntExtension.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/3/31.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

public extension Int {
    func boolValue() -> Bool {
        if self > 0 {
            return true
        }else{
            return false
        }
    }
    
    
    // MARK: - 十进制转二进制字符串
    func decTobin() -> String {
        var num = self
        var str = ""
        for i in 0..<7 {
            str = i > 0 ? "\(num % 2)," + str : "\(num % 2)" + str
            num /= 2
        }
        return str
    }
}
