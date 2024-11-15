import 'ble_base.dart';

class BleNotificationSettingsToIOS
    extends BleBase<BleNotificationSettingsToIOS> {
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
  static const String BAND = "bandapp";
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
    BAND: 1 << 16,
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
    DISCORD: 1<<29
  };

  int mNotificationBits = 0;

  BleNotificationSettingsToIOS();

  @override
  String toString() {
    return "BleNotificationSettingsToIOS(mNotificationBits = $mNotificationBits )";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mNotificationBits"] = mNotificationBits;
    return map;
  }

  @override
  bool isEnabled(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS.BIT_MASKS[bundleId];
    if (mNotificationBits & bitMask > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  enable(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS.BIT_MASKS[bundleId];
    mNotificationBits |= bitMask;
  }

  @override
  disable(String bundleId) {
    int bitMask = BleNotificationSettingsToIOS.BIT_MASKS[bundleId];
    mNotificationBits &= ~bitMask;
  }
}
