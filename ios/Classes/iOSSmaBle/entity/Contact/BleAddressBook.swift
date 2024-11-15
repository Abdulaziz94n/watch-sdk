//
//  BleAddressBook.swift
//  SmartV3
//
//  Created by SMA on 2020/9/2.
//  Copyright © 2020 KingHuang. All rights reserved.
//

import Foundation

open class BleAddressBook: BleWritable {

    override var mLengthToWrite: Int {
        BleContactPerson.ITEM_LENGTH*addBook.count
    }
    public var addBook : [BleContactPerson] = []
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    public init(array: [BleContactPerson]) {
        super.init()
        addBook = array
       
    }
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode() {
        super.encode()
        writeArray(addBook)
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleAddressBook{
        var array : [BleContactPerson] = []
        let arrayToPerson : Array<[String:Any]> = dic["addressBook"] as! Array<[String:Any]>
        for item in arrayToPerson{
            let person = BleContactPerson().dictionaryToObjct(item)
            array.append(person)
        }
        return BleAddressBook.init(array: array)
    }
}
