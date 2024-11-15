//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

//class BleUtils {
//    static let XMODEM_OK: UInt8 = 0x00
//    static let XMODEM_DENIED: UInt8 = 0x10
//    static let XMODEM_LOW_POWER: UInt8 = 0x11
//    static let XMODEM_TIMEOUT: UInt8 = 0x12
//
//    static func getXModemStatus(_ status: UInt8) -> String {
//        switch status {
//        case XMODEM_OK:
//            return "XMODEM_OK"
//        case XMODEM_DENIED:
//            return "XMODEM_DENIED"
//        case XMODEM_LOW_POWER:
//            return "XMODEM_LOW_POWER"
//        case XMODEM_TIMEOUT:
//            return "XMODEM_TIMEOUT"
//        default:
//            return "UNKNOWN"
//        }
//    }
//}


public extension String {
    
    var bytes: Array<UInt8> {
        data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }
    
    subscript(bounds: CountableRange<Int>) -> String {
        
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ..< index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let string = self[index(startIndex, offsetBy: bounds.lowerBound) ... index(startIndex, offsetBy: bounds.upperBound)]
        return String(string)
    }
    
    subscript(index: Int) -> String {
        let character = self[self.index(startIndex, offsetBy: index)]
        return String(character)
    }
}

public extension Data {
    
    var bytes: Array<UInt8> {
        Array(self)
    }
}
