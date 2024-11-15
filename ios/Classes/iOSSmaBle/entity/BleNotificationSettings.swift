//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleNotificationSettings: BleWritable {
    static let ITEM_LENGTH = 4

//    static let MIRROR_PHONE = "mirror.phone"
//    static let CALL = "com.apple.mobilephone"
//    static let SMS = "com.apple.MobileSMS"
//    static let EMAIL = "com.apple.mobilemail"
//    static let SKYPE = "com.skype.skype"
//    static let FACEBOOK_MESSENGER = "com.facebook.Messenger"
//    static let WHATS_APP = "net.whatsapp.WhatsApp"
//    static let LINE = "jp.naver.line"
//    static let INSTAGRAM = "com.burbn.instagram"
//    static let KAKAO_TALK = "com.iwilab.KakaoTalk"
//    static let GMAIL = "com.google.Gmail"
//    static let TWITTER = "com.atebits.Tweetie2"
//    static let LINKED_IN = "com.linkedin.LinkedIn"
//    static let SINA_WEIBO = "com.sina.weibo"
//    static let QQ = "com.tencent.mqq"
//    static let WE_CHAT = "com.tencent.xin"

    /// 镜像手机（消息全部推送）
    public static let MIRROR_PHONE = "mirror_phone"
    /// 来电
    public static let CALL = "tel"
    /// 信息
    public static let SMS = "sms"
    /// 邮件
    public static let EMAIL = "mailto"
    public static let SKYPE = "skype"
    public static let FACEBOOK = "fbauth2"
    public static let WHATS_APP = "whatsapp"
    public static let LINE = "line"
    public static let INSTAGRAM = "instagram"
    public static let KAKAO_TALK = "kakaolink"
    public static let GMAIL = "googlegmail"
    public static let TWITTER = "twitter"
    public static let LINKED_IN = "linkedin"
    public static let SINA_WEIBO = "sinaweibo"
    public static let QQ = "mqq"
    public static let WE_CHAT = "wechat"
    //public static let BAND = "bandapp"
    public static let Messenger = "Messenger"
    public static let TELEGRAM = "telegram"
    public static let BETWEEN = "between"
    public static let NAVERCAFE = "navercafe"
    public static let YOUTUBE = "youtube"
    public static let NETFLIX = "nflx"
    public static let Tik_Tok = "awemesso" // 注意这个是国外版本的抖音, 不要搞错了
    public static let SNAPCHAT = "snapchat"
    public static let AMAZON = "com.amazon.mobile.shopping"
    public static let UBER = "uberx"
    public static let LYFT = "co.uk.weinstant.instant"
    public static let GOOGLE_MAPS = "GOOGLE_MAPS"
    public static let SLACK = "SLACK"
    public static let Discord = "discord"

    // 最初始支持的APP，之后如果有新增app，再BleCache中增加，即修改BleCache.mNotificationBundleIds
    // 计算属性的返回值，这个原始的数组千万不要修改，谢谢
    public static let ORIGIN_BUNDLE_IDS = [
        MIRROR_PHONE, CALL, SMS, EMAIL,
        SKYPE, FACEBOOK, WHATS_APP, LINE,
        INSTAGRAM, KAKAO_TALK, GMAIL, TWITTER,
        LINKED_IN, SINA_WEIBO, QQ, WE_CHAT,
    ]

    public static let BIT_MASKS: [String: Int] = [
        MIRROR_PHONE: 1, CALL: 1 << 1, SMS: 1 << 2, EMAIL: 1 << 3,
        
        SKYPE: 1 << 4, FACEBOOK: 1 << 5, WHATS_APP: 1 << 6, LINE: 1 << 7,
        INSTAGRAM: 1 << 8, KAKAO_TALK: 1 << 9, GMAIL: 1 << 10, TWITTER: 1 << 11,
        LINKED_IN: 1 << 12, SINA_WEIBO: 1 << 13, QQ: 1 << 14, WE_CHAT: 1 << 15, Messenger: 1 << 16,TELEGRAM: 1 << 17,BETWEEN: 1 << 18,NAVERCAFE: 1 << 19,YOUTUBE: 1 << 20,NETFLIX: 1 << 21, Tik_Tok: 1 << 22, SNAPCHAT: 1 << 23, AMAZON: 1 << 24, UBER: 1 << 25,
        LYFT: 1 << 26, GOOGLE_MAPS: 1 << 27, SLACK: 1 << 28, Discord: 1 << 29
    ]

    override var mLengthToWrite: Int {
        BleNotificationSettings.ITEM_LENGTH
    }

    var mNotificationBits = 0

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()  // 32769 25165824
        writeInt32(mNotificationBits)
    }

    override func decode() {
        super.decode()
        mNotificationBits = Int(readInt32())
    }

    public func isEnabled(_ bundleId: String) -> Bool {
        if let bitMask = BleNotificationSettings.BIT_MASKS[bundleId] {
            return mNotificationBits & bitMask > 0
        }

        return false
    }

    public func enable(_ bundleId: String) {
        if let bitMask = BleNotificationSettings.BIT_MASKS[bundleId] {
            mNotificationBits |= bitMask
        }
    }

    public func disable(_ bundleId: String) {
        if let bitMask = BleNotificationSettings.BIT_MASKS[bundleId] {
            mNotificationBits &= ~bitMask
        }
    }

    public func toggle(_ bundleId: String) {
        if let bitMask = BleNotificationSettings.BIT_MASKS[bundleId] {
            mNotificationBits ^= bitMask
        }
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mNotificationBits = try container.decode(Int.self, forKey: .mNotificationBits)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mNotificationBits, forKey: .mNotificationBits)
    }

    private enum CodingKeys: String, CodingKey {
        case mNotificationBits
    }

    open override var description: String {
        var desc = "BleNotificationSettings("
        for (bundleId, _) in BleNotificationSettings.BIT_MASKS {
            desc += "\(bundleId): \(isEnabled(bundleId)), "
        }
        desc.removeLast(2)
        desc += ")"
        return desc
    }
    
    public func toDictionary()->[String:Any]{

        return ["mNotificationBits":mNotificationBits]
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleNotificationSettings{
        let settings : BleNotificationSettings = BleCache.shared.getObjectNotNil(.NOTIFICATION_REMINDER)
        settings.mNotificationBits = dic["mNotificationBits"] as? Int ?? 0
        return settings
    }
}
