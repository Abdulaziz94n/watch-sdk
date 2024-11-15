//
//  DateExtension.swift
//  blesdk3
//
//  Created by 叩鼎科技 on 2023/4/4.
//  Copyright © 2023 szabh. All rights reserved.
//

import UIKit

extension Date {
    
    /// EZSE : Get the year from the date
    public var year: Int {
        return Calendar.init(identifier: .gregorian).component(Calendar.Component.year, from: self)
    }
    
    /// EZSE : Get the month from the date
    public var month: Int {
        return Calendar.init(identifier: .gregorian).component(Calendar.Component.month, from: self)
    }
    
    // EZSE : Get the day from the date
    public var day: Int {
        return Calendar.init(identifier: .gregorian).component(.day, from: self)
    }
    
    /// EZSE: Get the hours from date
    public var hour: Int {
        return Calendar.init(identifier: .gregorian).component(.hour, from: self)
    }
    
    /// EZSE: Get the minute from date
    public var minute: Int {
        return Calendar.init(identifier: .gregorian).component(.minute, from: self)
    }
    
    /// EZSE: Get the second from the date
    public var second: Int {
        return Calendar.init(identifier: .gregorian).component(.second, from: self)
    }
    
    
}
