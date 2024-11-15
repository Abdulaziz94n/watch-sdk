import 'ble_base.dart';

class BleNotification extends BleBase<BleNotification> {
  static const int CATEGORY_INCOMING_CALL = 0x01;
  static const int CATEGORY_MESSAGE = 0x7F;

  static const String PACKAGE_MISSED_CALL = "com.android.mobilephone";
  static const String PACKAGE_SMS = "com.android.mms";

  static const String ANDROID_EMAIL = "com.android.email";

  //以下应用建议默认打开推送开关
  static const String SKYPE = "com.skype.raider";
  static const String FACEBOOK_MESSENGER = "com.facebook.orca";
  static const String FACEBOOK_MESSENGER_LITE = "com.facebook.mlite";
  static const String FACEBOOK = "com.facebook.katana";
  static const String FACEBOOK_LITE = "com.facebook.lite";
  static const String WHATS_APP = "com.whatsapp";
  static const String LINE = "jp.naver.line.android";
  static const String INSTAGRAM = "com.instagram.android";
  static const String KAKAO_TALK = "com.kakao.talk";
  static const String GMAIL = "com.google.android.gm";
  static const String TWITTER = "com.twitter.android";
  static const String LINKED_IN = "com.linkedin.android";
  static const String SINA_WEIBO = "com.sina.weibo";
  static const String QQ = "com.tencent.mobileqq";
  static const String WE_CHAT = "com.tencent.mm";
  static const String OUT_LOOK = "com.microsoft.office.outlook";
  static const String OUT_LOOK2 = "park.outlook.sign.in.client";
  static const String YAHOO_MAIL = "com.yahoo.mobile.client.android.mail";
  static const String VIBER = "com.viber.voip";
  static const String BAND = "com.nhn.android.band";
  static const String TELEGRAM = "org.telegram.messenger";
  static const String BETWEEN = "kr.co.vcnc.android.couple";
  static const String NAVERCAFE = "com.nhn.android.navercafe";
  static const String YOUTUBE = "com.google.android.youtube";
  static const String NETFLIX = "com.netflix.mediaclient";
  static const String GOOGLE_DUO = "com.google.android.apps.tachyon";
  static const String SNAPCHAT = "com.snapchat.android";
  static const String DISCORD = "com.discord";
  //以上应用建议默认打开推送开关

  static const String HUAWEI_SYSTEM_MANAGER = "com.huawei.systemmanager";

  //电话应用
  static const String ANDROID_INCALLUI = "com.android.incallui";
  static const String ANDROID_TELECOM = "com.android.server.telecom";
  static const String GOOGLE_TELECOM = "com.google.android.dialer";
  static const String SAMSUNG_INCALLUI = "com.samsung.android.incallui";
  static const String SAMSUNG_TELECOM = "com.samsung.android.dialer";
  static const String ONE_PLUS_TELECOM = "com.oneplus.dialer";

  //短信应用
  static const String ANDROID_MMS = "com.android.mms";
  static const String ANDROID_MMS_SERVICE = "com.android.mms.service";
  static const String GOOGLE_MMS = "com.google.android.apps.messaging";
  static const String SAMSUNG_MMS = "com.samsung.android.messaging";
  static const String ONE_PLUS_MMS = "com.oneplus.mms";

  int mCategory = 0;
  int mTime = 0; // ms
  String mPackage = "";
  String mTitle = "";
  String mContent = "";

  BleNotification();

  @override
  String toString() {
    return "BleNotification(mCategory=$mCategory, mTime=$mTime, mPackage=$mPackage"
        ", mTitle=$mTitle, mContent=$mContent)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mCategory"] = mCategory;
    map["mTime"] = mTime;
    map["mPackage"] = mPackage;
    map["mTitle"] = mTitle;
    map["mContent"] = mContent;
    return map;
  }
}
