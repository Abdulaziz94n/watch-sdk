import 'ble_base.dart';

class BleNotificationSettingsToIOS2
    extends BleBase<BleNotificationSettingsToIOS2> {
  //other app URL Type
  static const String MIRROR_PHONE = "mirror_phone";
  static const String CALL = "tel";
  static const String SMS = "sms";
  static const String EMAIL = "mailto";
  static const String SKYPE = "skype";
  static const String FACEBOOK_MESSENGER = "fbauth2";
  static const String WHATS_APP = "whatsapp";
  static const String LINE = "line";
  static const String INSTAGRAM = "instagram";
  static const String KAKAO_TALK = "kakaolink";
  static const String GMAIL = "googlegmail";
  static const String TWITTER = "twitter";
  static const String LINKED_IN = "linkedin";
  static const String SINA_WEIBO = "sinaweibo";
  static const String QQ = "mqq";
  static const String WE_CHAT = "wechat";
  static const String Messenger = "Messenger";
  //static const String BAND = "bandapp";
  static const String TELEGRAM = "telegram";
  static const String BETWEEN = "between";
  static const String NAVERCAFE = "navercafe";
  static const String YOUTUBE = "youtube";
  static const String NETFLIX = "nflx";
  static const String Tik_Tok = "Tik_Tok"; // 注意这个是国外版本的抖音, 不要搞错了
  static const String SNAPCHAT = "SNAPCHAT";
  static const String AMAZON = "AMAZON";
  static const String UBER = "UBER";
  static const String LYFT = "LYFT";
  static const String GOOGLE_MAPS = "GOOGLE_MAPS";
  static const String SLACK = "SLACK";
  static const String DISCORD = "DISCORD";
  // 2023-08-04 新增
  static const String TumBlr = "TumBlr";
  static const String Pinterest = "Pinterest";
  static const String Zalo = "Zalo";
  static const String IMO = "IMO";
  static const String VKontakte = "VKontakte";
  // 2023-08-04 新增
  static const String TikTok_KOR = "TikTok_KOR"; // 韩国版TikTok
  static const String Naver_Band = "Naver_Band";
  static const String NAVER_APP = "NAVER_APP";
  static const String Naver_Cafe = "Naver_Cafe";  // 特殊名称 Naver Café
  static const String Signal = "Signal";
  static const String Nate_On = "Nate_On";
  static const String Daangn_Market = "Daangn_Market";
  static const String Kiwoom_Securities = "Kiwoom_Securities";
  static const String Daum_Cafe = "Daum_Cafe";
  // 2023-12-26 新增
  static const String Vieber_Push = "Vieber_Push";
  // 2024-05-24 新增, 添加美团 钉钉
  static const String Meituan_Push = "Meituan_Push";
  static const String Dingding_Push = "Dingding_Push";



  static const Map BIT_MASKS = {
    MIRROR_PHONE: 1,
    CALL: 1 << 1,
    SMS: 1 << 2,
    EMAIL: 1 << 3,
    SKYPE: 1 << 4,
    FACEBOOK_MESSENGER: 1 << 5,
    WHATS_APP: 1 << 6,
    LINE: 1 << 7,
    INSTAGRAM: 1 << 8,
    KAKAO_TALK: 1 << 9,
    GMAIL: 1 << 10,
    TWITTER: 1 << 11,
    LINKED_IN: 1 << 12,
    SINA_WEIBO: 1 << 13,
    QQ: 1 << 14,
    WE_CHAT: 1 << 15,
    Messenger: 1 << 16,
    TELEGRAM: 1 << 17,
    BETWEEN: 1 << 18,
    NAVERCAFE: 1 << 19,
    YOUTUBE: 1 << 20,
    NETFLIX: 1 << 21,
    Tik_Tok: 1 << 22,
    SNAPCHAT: 1 << 23,
    AMAZON: 1 << 24,
    UBER: 1 << 25,
    LYFT: 1 << 26,
    GOOGLE_MAPS: 1 << 27,
    SLACK: 1 << 28,
    DISCORD: 1<<29,
    // 2023-08-04 新增
    TumBlr: 1 << 30,
    Pinterest: 1 << 31,
    Zalo: 1 << 32,
    IMO: 1 << 33,
    VKontakte: 1 << 34,
    // 2023-08-04 新增
    TikTok_KOR: 1 << 35,
    Naver_Band: 1 << 36,
    NAVER_APP: 1 << 37,
    Naver_Cafe: 1 << 38,
    Signal: 1 << 39,
    Nate_On: 1 << 40,
    Daangn_Market: 1 << 41,
    Kiwoom_Securities: 1 << 42,
    Daum_Cafe: 1 << 43,
    Vieber_Push: 1 << 44,
    Meituan_Push: 1 << 45,
    Dingding_Push: 1 << 46,
  };

  int mNotificationBits = 0;

  BleNotificationSettingsToIOS2();

  @override
  String toString() {
    return "BleNotificationSettingsToIOS2(mNotificationBits = $mNotificationBits )";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mNotificationBits"] = mNotificationBits;
    return map;
  }

  @override
  bool isEnabled(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS2.BIT_MASKS[bundleId];
    if (mNotificationBits & bitMask > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  enable(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS2.BIT_MASKS[bundleId];
    mNotificationBits |= bitMask;
  }

  @override
  disable(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS2.BIT_MASKS[bundleId];
    mNotificationBits &= ~bitMask;
  }
}
