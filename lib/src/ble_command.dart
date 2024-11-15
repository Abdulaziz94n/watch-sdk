import 'package:sprintf/sprintf.dart';

Map<BleCommand, int> _bleCommandMapping = {
  BleCommand.UPDATE: 0x01,
  BleCommand.SET: 0x02,
  BleCommand.CONNECT: 0x03,
  BleCommand.PUSH: 0x04,
  BleCommand.DATA: 0x05,
  BleCommand.CONTROL: 0x06,
  BleCommand.IO: 0x07,
  BleCommand.NONE: 0xff,
};

enum BleCommand {
  UPDATE,
  SET,
  CONNECT,
  PUSH,
  DATA,
  CONTROL,
  IO,
  NONE;

  int toKey() {
    if (_bleCommandMapping.containsKey(this)) {
      return _bleCommandMapping[this] ?? 0xff;
    }
    return 0xff;
  }

  static BleCommand of(int value) {
    for (var element in BleCommand.values) {
      if (element.toKey() == value) {
        return element;
      }
    }
    return BleCommand.NONE;
  }

  @override
  String toString() {
    return "${sprintf("0x%02X_", [toKey()])}$name";
  }

  List<BleKey> getBleKeys() {
    List<BleKey> tmp = [];
    for (var element in BleKey.values) {
      if (element.toKey() >>> 8 == toKey()) {
        tmp.add(element);
      }
    }
    return tmp;
  }
}

Map<BleKey, int> _bleKeyValueMapping = {
  // UPDATE
  BleKey.OTA: 0x0101,
  BleKey.XMODEM: 0x0102,

  // SET
  BleKey.TIME: 0x0201,
  BleKey.TIME_ZONE: 0x0202,
  BleKey.POWER: 0x0203,
  BleKey.FIRMWARE_VERSION: 0x0204,
  BleKey.BLE_ADDRESS: 0x0205,
  BleKey.USER_PROFILE: 0x0206,
  BleKey.STEP_GOAL: 0x0207,
  BleKey.BACK_LIGHT: 0x0208,
  BleKey.SEDENTARINESS: 0x0209,
  BleKey.NO_DISTURB_RANGE: 0x020A,
  BleKey.VIBRATION: 0x020B,
  BleKey.GESTURE_WAKE: 0x020C,
  BleKey.HR_ASSIST_SLEEP: 0x020D,
  BleKey.HOUR_SYSTEM: 0x020E,
  BleKey.LANGUAGE: 0x020F,
  BleKey.ALARM: 0x0210,
  BleKey.UNIT_SET: 0x0211,
  BleKey.COACHING: 0x0212,
  BleKey.FIND_PHONE: 0x0213,
  BleKey.NOTIFICATION_REMINDER: 0x0214,
  BleKey.ANTI_LOST: 0x0215,
  BleKey.HR_MONITORING: 0x0216,
  BleKey.UI_PACK_VERSION: 0x0217,
  BleKey.LANGUAGE_PACK_VERSION: 0x0218,
  BleKey.SLEEP_QUALITY: 0x0219,
  BleKey.GIRL_CARE: 0x021A,
  BleKey.TEMPERATURE_DETECTING: 0x021B,
  BleKey.AEROBIC_EXERCISE: 0x021C,
  BleKey.TEMPERATURE_UNIT: 0x021D,
  BleKey.DATE_FORMAT: 0x021E,
  BleKey.WATCH_FACE_SWITCH: 0x021F,
  BleKey.AGPS_PREREQUISITE: 0x0220,
  BleKey.DRINK_WATER: 0x0221,
  BleKey.SHUTDOWN: 0x0222,
  BleKey.APP_SPORT_DATA: 0x0223,
  BleKey.REAL_TIME_HEART_RATE: 0x0224,
  BleKey.BLOOD_OXYGEN_SET: 0x0225,
  BleKey.WASH_SET: 0x0226,
  BleKey.WATCHFACE_ID: 0x0227,
  BleKey.IBEACON_SET: 0x0228,
  BleKey.MAC_QRCODE: 0x0229,
  BleKey.REAL_TIME_TEMPERATURE: 0x0230,
  BleKey.REAL_TIME_BLOOD_PRESSURE: 0x0231,
  BleKey.TEMPERATURE_VALUE: 0x0232,
  BleKey.GAME_SET: 0x0233,
  BleKey.FIND_WATCH: 0x0234,
  BleKey.SET_WATCH_PASSWORD: 0x0235,
  BleKey.REALTIME_MEASUREMENT: 0x0236,
  BleKey.POWER_SAVE_MODE: 0x0237,
  BleKey.BAC_SET: 0x0238,
  BleKey.CALORIES_GOAL: 0x0239,
  BleKey.DISTANCE_GOAL: 0x023A,
  BleKey.SLEEP_GOAL: 0x023B,
  BleKey.LOVE_TAP_USER: 0x023C,
  BleKey.MEDICATION_REMINDER: 0x023D,
  BleKey.DEVICE_INFO: 0x023E,
  BleKey.HR_WARNING_SET: 0x023F,
  BleKey.SLEEP_MONITORING: 0x0240,
  BleKey.NOTIFICATION_REMINDER2: 0x0250,

  BleKey.REALTIME_LOG: 0x02F9,
  BleKey.GSENSOR_OUTPUT: 0x02FA,
  BleKey.GSENSOR_RAW: 0x02FB,
  BleKey.MOTION_DETECT: 0x02FC,
  BleKey.LOCATION_GGA: 0x02FD,
  BleKey.RAW_SLEEP: 0x02FE,
  BleKey.NO_DISTURB_GLOBAL: 0x02FF,

  // CONNECT
  BleKey.IDENTITY: 0x0301,
  BleKey.SESSION: 0x0302,

  // PUSH
  BleKey.NOTIFICATION: 0x0401,
  BleKey.MUSIC_CONTROL: 0x0402,
  BleKey.SCHEDULE: 0x0403,
  BleKey.WEATHER_REALTIME: 0x0404,
  BleKey.WEATHER_FORECAST: 0x0405,
  BleKey.HID: 0x0406,
  BleKey.WORLD_CLOCK: 0x0407,
  BleKey.STOCK: 0x0408,
  BleKey.SMS_QUICK_REPLY_CONTENT: 0x0409,
  BleKey.NOTIFICATION2: 0x040A,
  BleKey.NEWS_FEED: 0x040B,
  BleKey.WEATHER_REALTIME2: 0x040C,
  BleKey.WEATHER_FORECAST2: 0x040D,

  // DATA
  BleKey.DATA_ALL: 0x05ff,
  BleKey.ACTIVITY_REALTIME: 0x0501,
  BleKey.ACTIVITY: 0x0502,
  BleKey.HEART_RATE: 0x0503,
  BleKey.BLOOD_PRESSURE: 0x0504,
  BleKey.SLEEP: 0x0505,
  BleKey.WORKOUT: 0x0506,
  BleKey.LOCATION: 0x0507,
  BleKey.TEMPERATURE: 0x0508,
  BleKey.BLOOD_OXYGEN: 0x0509,
  BleKey.HRV: 0x050A,
  BleKey.LOG: 0x050B,
  BleKey.SLEEP_RAW_DATA: 0x050C,
  BleKey.PRESSURE: 0x050D,
  BleKey.WORKOUT2: 0x050E,
  BleKey.MATCH_RECORD: 0x050F,
  BleKey.BLOOD_GLUCOSE: 0x0510,

  // CONTROL
  BleKey.CAMERA: 0x0601,
  BleKey.REQUEST_LOCATION: 0x0602,
  BleKey.INCOMING_CALL: 0x0603,
  BleKey.APP_SPORT_STATE: 0x0604,
  BleKey.CLASSIC_BLUETOOTH_STATE: 0x0605,
  BleKey.DEVICE_SMS_QUICK_REPLY: 0x0607,
  BleKey.LOVE_TAP: 0x0608,

  // IO
  BleKey.WATCH_FACE: 0x0701,
  BleKey.AGPS_FILE: 0x0702,
  BleKey.FONT_FILE: 0x0703,
  BleKey.CONTACT: 0x0704,
  BleKey.UI_FILE: 0x0705,
  BleKey.DEVICE_FILE: 0x0706,
  BleKey.LANGUAGE_FILE: 0x0707,
  BleKey.BRAND_INFO_FILE: 0x0708,
  BleKey.QRCODE: 0x0709,
  BleKey.THIRD_PARTY_DATA: 0x070A,//第三方应用的通信
  BleKey.QRCODE2: 0x070B,//二维码2
  BleKey.LOGO_FILE: 0x070C,//自定义logo的
  BleKey.OTA_FILE: 0x070D,//ota固件

  // 0xFFFF
  BleKey.NONE: 0xFFFFF
};

enum BleKey {
  // UPDATE
  OTA,
  XMODEM,

  // SET
  TIME,
  TIME_ZONE,
  POWER,
  FIRMWARE_VERSION,
  BLE_ADDRESS,
  USER_PROFILE,
  STEP_GOAL,
  BACK_LIGHT,
  SEDENTARINESS,
  NO_DISTURB_RANGE,
  VIBRATION,
  GESTURE_WAKE,
  HR_ASSIST_SLEEP,
  HOUR_SYSTEM,
  LANGUAGE,
  ALARM,
  UNIT_SET, //公英制单位设置
  COACHING,
  FIND_PHONE,
  NOTIFICATION_REMINDER,
  ANTI_LOST,
  HR_MONITORING,
  UI_PACK_VERSION,
  LANGUAGE_PACK_VERSION,
  SLEEP_QUALITY,
  GIRL_CARE,
  TEMPERATURE_DETECTING,
  AEROBIC_EXERCISE,
  TEMPERATURE_UNIT,
  DATE_FORMAT,
  WATCH_FACE_SWITCH,
  AGPS_PREREQUISITE,
  DRINK_WATER,
  SHUTDOWN,
  APP_SPORT_DATA,
  REAL_TIME_HEART_RATE,
  BLOOD_OXYGEN_SET,
  WASH_SET,
  WATCHFACE_ID,
  IBEACON_SET,
  MAC_QRCODE,
  REAL_TIME_TEMPERATURE,
  REAL_TIME_BLOOD_PRESSURE,
  TEMPERATURE_VALUE, //体温标定
  GAME_SET, //家长控制, 游戏时间设置
  FIND_WATCH, //找手机
  SET_WATCH_PASSWORD, //设置手表密码
  REALTIME_MEASUREMENT, //实时测量
  POWER_SAVE_MODE, //省电模式
  BAC_SET, // 酒精浓度检测设置
  CALORIES_GOAL, //卡路里目标
  DISTANCE_GOAL, //距离目标
  SLEEP_GOAL, //睡眠目标
  LOVE_TAP_USER, //LoveTap联系人
  MEDICATION_REMINDER, //吃药提醒设置
  DEVICE_INFO, //返回设备信息,精简的
  HR_WARNING_SET, //心率警告设置
  SLEEP_MONITORING, //睡眠设置
  NOTIFICATION_REMINDER2, // iOS 推送消息开关指令2

  REALTIME_LOG,
  GSENSOR_OUTPUT,
  GSENSOR_RAW,
  MOTION_DETECT,
  LOCATION_GGA,
  RAW_SLEEP,
  NO_DISTURB_GLOBAL,

  // CONNECT
  IDENTITY,
  SESSION,

  // PUSH
  NOTIFICATION,
  MUSIC_CONTROL,
  SCHEDULE,
  WEATHER_REALTIME,
  WEATHER_FORECAST,
  HID,
  WORLD_CLOCK,
  STOCK,
  SMS_QUICK_REPLY_CONTENT,
  NOTIFICATION2, //带有Phone字段的推送协议，应用于支持短信快捷回复的设备
  NEWS_FEED, //推送Newsfeed消息
  WEATHER_REALTIME2,
  WEATHER_FORECAST2,

  // DATA
  DATA_ALL,
  ACTIVITY_REALTIME,
  ACTIVITY,
  HEART_RATE,
  BLOOD_PRESSURE,
  SLEEP,
  WORKOUT,
  LOCATION,
  TEMPERATURE,
  BLOOD_OXYGEN,
  HRV,
  LOG,
  SLEEP_RAW_DATA,
  PRESSURE,
  WORKOUT2,
  MATCH_RECORD,
  BLOOD_GLUCOSE,

  // CONTROL
  CAMERA,
  REQUEST_LOCATION,
  INCOMING_CALL,
  APP_SPORT_STATE,
  CLASSIC_BLUETOOTH_STATE,
  DEVICE_SMS_QUICK_REPLY,
  LOVE_TAP, //loveTap消息

  // IO
  WATCH_FACE,
  AGPS_FILE,
  FONT_FILE,
  CONTACT,
  UI_FILE,
  DEVICE_FILE,
  LANGUAGE_FILE,
  BRAND_INFO_FILE,
  QRCODE,
  THIRD_PARTY_DATA,//第三方应用的通信
  QRCODE2,//二维码2
  LOGO_FILE,//自定义logo的
  OTA_FILE,//ota固件
  GPS_FIRMWARE_FILE,//gps固件

  // 0xFFFF
  NONE;

  int toKey() {
    if (_bleKeyValueMapping.containsKey(this)) {
      return _bleKeyValueMapping[this] ?? 0xffff;
    }
    return 0xffff;
  }

  static BleKey of(int value) {
    for (var element in BleKey.values) {
      if (element.toKey() == value) {
        return element;
      }
    }
    return BleKey.NONE;
  }

  @override
  String toString() {
    return "${sprintf("0x%04X_", [toKey()])}$name";
  }

  List<BleKeyFlag> getBleKeyFlags() {
    switch (this) {
      // UPDATE
      case OTA:
      case XMODEM:
        return [BleKeyFlag.UPDATE];
      // SET
      case POWER:
      case FIRMWARE_VERSION:
      case BLE_ADDRESS:
      case UI_PACK_VERSION:
      case LANGUAGE_PACK_VERSION:
      case DEVICE_FILE:
      case RAW_SLEEP:
      case DEVICE_INFO:
        return [BleKeyFlag.READ];
      case TIME:
      case NOTIFICATION_REMINDER:
      case SLEEP_QUALITY:
      case GIRL_CARE:
      case TEMPERATURE_DETECTING:
      case SHUTDOWN:
      case APP_SPORT_DATA:
      case REAL_TIME_HEART_RATE:
      case IBEACON_SET:
      case MAC_QRCODE:
      case REAL_TIME_TEMPERATURE:
      case REAL_TIME_BLOOD_PRESSURE:
      case SET_WATCH_PASSWORD:
      case REALTIME_MEASUREMENT:
      case BAC_SET:
      case TIME_ZONE:
      case HR_WARNING_SET:
      case SLEEP_MONITORING:
        return [BleKeyFlag.UPDATE];
      case NOTIFICATION_REMINDER2:
        return [BleKeyFlag.UPDATE, BleKeyFlag.READ];
      case CALORIES_GOAL:
      case DISTANCE_GOAL:
      case SLEEP_GOAL:
      case FIND_WATCH:
      case DRINK_WATER:
        return [BleKeyFlag.UPDATE];
      case USER_PROFILE:
      case STEP_GOAL:
      case BACK_LIGHT:
      case SEDENTARINESS:
      case NO_DISTURB_RANGE:
      case NO_DISTURB_GLOBAL:
      case VIBRATION:
      case GESTURE_WAKE:
      case HR_ASSIST_SLEEP:
      case HOUR_SYSTEM:
      case LANGUAGE:
      case ANTI_LOST:
      case HR_MONITORING:
      case AEROBIC_EXERCISE:
      case TEMPERATURE_UNIT:
      case DATE_FORMAT:
      case WATCH_FACE_SWITCH:
      case WATCHFACE_ID:
      case POWER_SAVE_MODE:
      case UNIT_SET:
        return [BleKeyFlag.UPDATE, BleKeyFlag.READ];
      case ALARM:
      case LOVE_TAP_USER:
      case MEDICATION_REMINDER:
        return [
          BleKeyFlag.CREATE,
          BleKeyFlag.DELETE,
          BleKeyFlag.UPDATE,
          BleKeyFlag.READ
        ];
      case COACHING:
        return [BleKeyFlag.CREATE, BleKeyFlag.UPDATE, BleKeyFlag.READ];
      // CONNECT
      case IDENTITY:
        return [BleKeyFlag.CREATE, BleKeyFlag.READ, BleKeyFlag.DELETE];
      // PUSH
      case NOTIFICATION:
      case MUSIC_CONTROL:
      case WEATHER_REALTIME:
      case WEATHER_FORECAST:
      case NOTIFICATION2:
      case NEWS_FEED:
      case WEATHER_REALTIME2:
      case WEATHER_FORECAST2:
        return [BleKeyFlag.UPDATE];
      case SCHEDULE:
        return [BleKeyFlag.CREATE, BleKeyFlag.DELETE, BleKeyFlag.UPDATE];
      case HID:
        return [BleKeyFlag.READ];
      case WORLD_CLOCK:
      case STOCK:
        return [
          BleKeyFlag.CREATE,
          BleKeyFlag.DELETE,
          BleKeyFlag.UPDATE,
          BleKeyFlag.READ,
          BleKeyFlag.RESET
        ];
      // DATA
      case DATA_ALL:
      case ACTIVITY_REALTIME:
        return [BleKeyFlag.READ];
      case ACTIVITY:
      case HEART_RATE:
      case BLOOD_PRESSURE:
      case SLEEP:
      case WORKOUT:
      case LOCATION:
      case TEMPERATURE:
      case BLOOD_OXYGEN:
      case HRV:
      case LOG:
      case SLEEP_RAW_DATA:
      case PRESSURE:
      case WORKOUT2:
      case BLOOD_GLUCOSE:
        return [BleKeyFlag.READ, BleKeyFlag.DELETE];
      // CONTROL
      case CAMERA:
        return [BleKeyFlag.UPDATE];
      case REQUEST_LOCATION:
        return [BleKeyFlag.CREATE];
      case INCOMING_CALL:
      case APP_SPORT_STATE:
      case CLASSIC_BLUETOOTH_STATE:
      case DEVICE_SMS_QUICK_REPLY:
      case LOVE_TAP:
        return [BleKeyFlag.UPDATE];
      // IO
      case WATCH_FACE:
        return [BleKeyFlag.UPDATE, BleKeyFlag.NONE];
      case AGPS_FILE:
      case FONT_FILE:
      case CONTACT:
      case UI_FILE:
      case LANGUAGE_FILE:
      case BRAND_INFO_FILE:
      case QRCODE:
      case THIRD_PARTY_DATA:
      case QRCODE2:
      case LOGO_FILE:
      case OTA_FILE:
      case GPS_FIRMWARE_FILE:
        return [BleKeyFlag.UPDATE];
      default:
        return [];
    }
  }
}

Map<BleKeyFlag, int> _bleKeyFlagMapping = {
  BleKeyFlag.UPDATE: 0x00,
  BleKeyFlag.READ: 0x10,
  BleKeyFlag.READ_CONTINUE: 0x11,
  BleKeyFlag.CREATE: 0x20,
  BleKeyFlag.DELETE: 0x30,
  BleKeyFlag.RESET: 0x40,
  BleKeyFlag.NONE: 0xff,
};

enum BleKeyFlag {
  UPDATE,
  READ,
  READ_CONTINUE,
  CREATE,
  DELETE,
  RESET,
  NONE;

  int toKey() {
    if (_bleKeyFlagMapping.containsKey(this)) {
      return _bleKeyFlagMapping[this] ?? 0xff;
    }
    return 0xff;
  }

  static BleKeyFlag of(int value) {
    for (var element in BleKeyFlag.values) {
      if (element.toKey() == value) {
        return element;
      }
    }
    return BleKeyFlag.NONE;
  }

  @override
  String toString() {
    return "${sprintf("0x%02X_", [toKey()])}$name";
  }
}
