//
//  BleMatchPlayer.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/4/15.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

/// 比赛设置球员信息
open class BleMatchPlayer: BleWritable {
    static let NAME_LENGTH = 25
    static let ITEM_LENGTH = NAME_LENGTH + 3
    
    
    /// 球员名字utf8编码
    public var mName = ""
    /// 球员号码
    public var mNum = 0
    /// 是否有黄牌（保留暂时没用到）
    public var hasYellowCard: Int = 0
    /// 是否是队长（保留暂时没用到）
    public var isCaptain: Int = 0
    
    init() {
        super.init()
    }
    init(mName: String, mNum: Int = 0) {
        super.init()
        self.mName = mName
        self.mNum = mNum
    }
    
    func modelToDictionary() -> [String : Any] {
        var obj = [String:Any]()
        obj["mName"] = self.mName
        obj["mNum"] = self.mNum
        obj["hasYellowCard"] = self.hasYellowCard
        obj["isCaptain"] = self.isCaptain
        return obj
    }
    
    override var mLengthToWrite: Int {
        return BleMatchPlayer.ITEM_LENGTH
    }
    
    override func encode() {
        super.encode()
        writeStringWithFix(mName, BleMatchPlayer.NAME_LENGTH)
        writeInt8(mNum)
        writeInt8(hasYellowCard)
        writeInt8(isCaptain)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mName = try container.decode(String.self, forKey: .mName)
        mNum = try container.decode(Int.self, forKey: .mNum)
        hasYellowCard = try container.decode(Int.self, forKey: .hasYellowCard)
        isCaptain = try container.decode(Int.self, forKey: .isCaptain)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mName, forKey: .mName)
        try container.encode(mNum, forKey: .mNum)
        try container.encode(hasYellowCard, forKey: .hasYellowCard)
        try container.encode(isCaptain, forKey: .isCaptain)
    }

    private enum CodingKeys: String, CodingKey {
        case mName, mNum, hasYellowCard, isCaptain
    }
    
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }
    
    open override var description: String {
        
        "BleMatchPlayer(mName:\(mName), mNum:\(mNum), hasYellowCard:\(hasYellowCard), isCaptain:\(isCaptain))"
    }
}
