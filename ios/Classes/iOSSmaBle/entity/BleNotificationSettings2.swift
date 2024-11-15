//
//  BleNotificationSettings2.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/8/4.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit


public enum BlePushAppType: String {

    /// 镜像手机（消息全部推送）
    case MIRROR_PHONE = "mirror_phone"
    /// 来电
    case CALL = "tel"
    /// 信息
    case SMS = "sms"
    /// 邮件
    case EMAIL = "mailto"
    
    case SKYPE = "skype"
    case FACEBOOK = "fbauth2"
    case WHATS_APP = "whatsapp"
    case LINE = "line"
    case INSTAGRAM = "instagram"
    case KAKAO_TALK = "kakaolink"
    case GMAIL = "googlegmail"
    case TWITTER = "twitter"
    case LINKED_IN = "linkedin"
    case SINA_WEIBO = "sinaweibo"
    case QQ = "mqq"
    case WE_CHAT = "wechat"
    case Messenger = "Messenger"
    //case BAND = "bandapp"
    case TELEGRAM = "telegram"
    case BETWEEN = "between"
    case NAVERCAFE = "navercafe"
    case YOUTUBE = "youtube"
    case NETFLIX = "nflx"
    case Tik_Tok = "awemesso" // 注意这个是国外版本的抖音, 不要搞错了
    case SNAPCHAT = "snapchat"
    case AMAZON = "com.amazon.mobile.shopping"
    case UBER = "uberx"
    case LYFT = "co.uk.weinstant.instant"
    case GOOGLE_MAPS = "GOOGLE_MAPS"
    case SLACK = "SLACK"
    case Discord = "discord"
    // 2023-08-04 新增, 主要针对于黑鲨定制
    case TumBlr = "TumBlr"
    case Pinterest = "Pinterest"
    case Zalo = "Zalo"
    case IMO = "IMO"
    case VKontakte = "VKontakte"
    // 2023-08-04 新增, 主要针对于COA 之前的K Fit
    case TikTok_KOR = "TikTok_KOR"  // 韩国版TikTok
    case Naver_Band = "Naver_Band"
    case NAVER_APP = "NAVER_APP"
    case Naver_Cafe = "Naver_Cafe"  /// 特殊名称 Naver Café
    case Signal = "Signal"
    case Nate_On = "Nate_On"
    case Daangn_Market = "Daangn_Market"
    case Kiwoom_Securities = "Kiwoom_Securities"
    case Daum_Cafe = "Daum_Cafe"
    // 2023-12-26 新增, 主要针对于SmartX Fit
    case Vieber_Push = "Vieber_Push"
    // 2024-05-24 新增, 添加美团 钉钉
    case Meituan_Push = "Meituan_Push"
    case Dingding_Push = "Dingding_Push"
}

open class BleNotificationSettings2: BleWritable {
    
    // 最初始支持的APP，之后如果有新增app，再BleCache中增加，即修改BleCache.mNotificationBundleIds
    // 计算属性的返回值，这个原始的数组千万不要修改，谢谢
    static let ORIGIN_BUNDLE_IDS = [
        BlePushAppType.MIRROR_PHONE.rawValue,
        BlePushAppType.CALL.rawValue,
        BlePushAppType.SMS.rawValue,
        BlePushAppType.EMAIL.rawValue,
        BlePushAppType.SKYPE.rawValue,
        BlePushAppType.FACEBOOK.rawValue,
        BlePushAppType.WHATS_APP.rawValue,
        BlePushAppType.LINE.rawValue,
        BlePushAppType.INSTAGRAM.rawValue,
        BlePushAppType.KAKAO_TALK.rawValue,
        BlePushAppType.GMAIL.rawValue,
        BlePushAppType.TWITTER.rawValue,
        BlePushAppType.LINKED_IN.rawValue,
        BlePushAppType.SINA_WEIBO.rawValue,
        BlePushAppType.QQ.rawValue,
        BlePushAppType.WE_CHAT.rawValue,
    ]

    static let BIT_MASKS: [String: UInt] = [
        BlePushAppType.MIRROR_PHONE.rawValue: 1,
        BlePushAppType.CALL.rawValue: 1 << 1,
        BlePushAppType.SMS.rawValue: 1 << 2,
        BlePushAppType.EMAIL.rawValue: 1 << 3,
        BlePushAppType.SKYPE.rawValue: 1 << 4,
        BlePushAppType.FACEBOOK.rawValue: 1 << 5,
        BlePushAppType.WHATS_APP.rawValue: 1 << 6,
        BlePushAppType.LINE.rawValue: 1 << 7,
        BlePushAppType.INSTAGRAM.rawValue: 1 << 8,
        BlePushAppType.KAKAO_TALK.rawValue: 1 << 9,
        BlePushAppType.GMAIL.rawValue: 1 << 10,
        BlePushAppType.TWITTER.rawValue: 1 << 11,
        BlePushAppType.LINKED_IN.rawValue: 1 << 12,
        BlePushAppType.SINA_WEIBO.rawValue: 1 << 13,
        BlePushAppType.QQ.rawValue: 1 << 14,
        BlePushAppType.WE_CHAT.rawValue: 1 << 15,
        BlePushAppType.Messenger.rawValue: 1 << 16,
        BlePushAppType.TELEGRAM.rawValue: 1 << 17,
        BlePushAppType.BETWEEN.rawValue: 1 << 18,
        BlePushAppType.NAVERCAFE.rawValue: 1 << 19,
        BlePushAppType.YOUTUBE.rawValue: 1 << 20,
        BlePushAppType.NETFLIX.rawValue: 1 << 21,
        BlePushAppType.Tik_Tok.rawValue: 1 << 22,
        BlePushAppType.SNAPCHAT.rawValue: 1 << 23,
        BlePushAppType.AMAZON.rawValue: 1 << 24,
        BlePushAppType.UBER.rawValue: 1 << 25,
        BlePushAppType.LYFT.rawValue: 1 << 26,
        BlePushAppType.GOOGLE_MAPS.rawValue: 1 << 27,
        BlePushAppType.SLACK.rawValue: 1 << 28,
        BlePushAppType.Discord.rawValue: 1 << 29,
        // 2023-08-04 新增, 主要针对于黑鲨定制
        BlePushAppType.TumBlr.rawValue: 1 << 30,
        BlePushAppType.Pinterest.rawValue: 1 << 31,
        BlePushAppType.Zalo.rawValue: 1 << 32,
        BlePushAppType.IMO.rawValue: 1 << 33,
        BlePushAppType.VKontakte.rawValue: 1 << 34,
        // 2023-08-04 新增, 主要针对于COA 之前的K Fit
        BlePushAppType.TikTok_KOR.rawValue: 1 << 35,
        BlePushAppType.Naver_Band.rawValue: 1 << 36,
        BlePushAppType.NAVER_APP.rawValue: 1 << 37,
        BlePushAppType.Naver_Cafe.rawValue: 1 << 38,
        BlePushAppType.Signal.rawValue: 1 << 39,
        BlePushAppType.Nate_On.rawValue: 1 << 40,
        BlePushAppType.Daangn_Market.rawValue: 1 << 41,
        BlePushAppType.Kiwoom_Securities.rawValue: 1 << 42,
        BlePushAppType.Daum_Cafe.rawValue: 1 << 43,
        BlePushAppType.Vieber_Push.rawValue: 1 << 44,
        BlePushAppType.Meituan_Push.rawValue: 1 << 45,
        BlePushAppType.Dingding_Push.rawValue: 1 << 46,
    ]

    private static let ITEM_LENGTH = 8
    override var mLengthToWrite: Int {
        BleNotificationSettings2.ITEM_LENGTH
    }

    var mNotificationBits :UInt = 0

    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    override func encode() {
        super.encode()
        writeUInt(mNotificationBits)
    }

    override func decode() {
        super.decode()
        mNotificationBits = UInt(readUInt64())
    }

    
    
    public func isEnabled(_ bundleId: String) -> Bool {
        if let bitMask = BleNotificationSettings2.BIT_MASKS[bundleId] {
            return mNotificationBits & bitMask > 0
        }

        return false
    }

    public func enable(_ bundleId: String) {
        if let bitMask = BleNotificationSettings2.BIT_MASKS[bundleId] {
            mNotificationBits |= bitMask
        }
    }

    public func disable(_ bundleId: String) {
        if let bitMask = BleNotificationSettings2.BIT_MASKS[bundleId] {
            mNotificationBits &= ~bitMask
        }
    }

    public func toggle(_ bundleId: String) {
        if let bitMask = BleNotificationSettings2.BIT_MASKS[bundleId] {
            mNotificationBits ^= bitMask
        }
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mNotificationBits = try container.decode(UInt.self, forKey: .mNotificationBits)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mNotificationBits, forKey: .mNotificationBits)
    }

    private enum CodingKeys: String, CodingKey {
        case mNotificationBits
    }

    open override var description: String {
        var desc = "BleNotificationSettings2("
        for (bundleId, _) in BleNotificationSettings2.BIT_MASKS {
            desc += "\(bundleId): \(isEnabled(bundleId)), "
        }
        desc.removeLast(2)
        desc += ")"
        return desc
    }
    
    public func toDictionary()->[String:Any]{

        return ["mNotificationBits":mNotificationBits]
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) -> BleNotificationSettings2 {
        let settings : BleNotificationSettings2 = BleCache.shared.getObjectNotNil(.NOTIFICATION_REMINDER2)
        settings.mNotificationBits = dic["mNotificationBits"] as? UInt ?? 0
        return settings
    }
}
