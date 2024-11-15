import 'dart:convert';
import 'dart:core';

import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

/// 用于存储设备信息到本地的key
const String kBleDeviceInfoPreferencesKey = "kBleDeviceInfoPreferencesKey";

/// 绑定的设备信息对象, 包含设备的蓝牙名称, mac地址, 设备支持那些功能的标记位等等
/// The bound device information object, including the device's Bluetooth name, MAC address, the flags of the functions supported by the device, etc.
class BleDeviceInfo {
  ///[mPlatform]
  static const String PLATFORM_NORDIC = "Nordic";
  static const String PLATFORM_REALTEK = "Realtek";
  static const String PLATFORM_MTK = "MTK";
  static const String PLATFORM_GOODIX = "Goodix";
  static const String PLATFORM_JL = "JL";

  ///[mPrototype]
  /// Nordic
  static const String PROTOTYPE_10G = "SMA-10G";
  static const String PROTOTYPE_GTM5 = "SMA-GTM5";
  static const String PROTOTYPE_F1N = "SMA-F1N";
  static const String PROTOTYPE_ND09 = "SMA-ND09";
  static const String PROTOTYPE_ND08 = "SMA-ND08";
  static const String PROTOTYPE_FA86 = "SMA_FA_86";
  static const String PROTOTYPE_MC11 = "SMA_MC_11";

  /// Realtek
  static const String PROTOTYPE_R4 = "SMA-R4";
  static const String PROTOTYPE_R5 = "SMA-R5";
  static const String PROTOTYPE_B5CRT = "SMA-B5CRT";
  static const String PROTOTYPE_F1RT = "SMA-F1RT";
  static const String PROTOTYPE_F2 = "SMA-F2";
  static const String PROTOTYPE_F3C = "SMA-F3C";
  static const String PROTOTYPE_F3R = "SMA-F3R";
  static const String PROTOTYPE_R7 = "SMA-R7";
  static const String PROTOTYPE_F13 = "SMA-F13";
  static const String PROTOTYPE_R10 = "R10";
  static const String PROTOTYPE_F6 = "F6";
  static const String PROTOTYPE_R9 = "R9";
  static const String PROTOTYPE_F7 = "F7";
  static const String PROTOTYPE_SW01 = "SMA-SW01";
  static const String PROTOTYPE_REALTEK_GTM5 = "REALTEK_GTM5";
  static const String PROTOTYPE_F1 = "SMA-F1";
  static const String PROTOTYPE_F2D = "SMA-F2D";
  static const String PROTOTYPE_F2R = "SMA-F2R";
  static const String PROTOTYPE_T78 = "T78";
  static const String PROTOTYPE_F5 = "F5";
  static const String PROTOTYPE_V1 = "SMA-V1";
  static const String PROTOTYPE_Y1 = "Y1";
  static const String PROTOTYPE_F3_LH = "F3-LH";
  static const String PROTOTYPE_V2 = "V2";
  static const String PROTOTYPE_Y3 = "Y3";
  static const String PROTOTYPE_R3PRO = "R3Pro";
  static const String PROTOTYPE_R10PRO = "R10Pro";
  static const String PROTOTYPE_Y2 = "Y2";
  static const String PROTOTYPE_F2PRO = "F2Pro";
  static const String PROTOTYPE_S2 = "S2";
  static const String PROTOTYPE_B9 = "B9";
  static const String PROTOTYPE_F13J = "F13J";
  static const String PROTOTYPE_R11 = "R11";
  static const String PROTOTYPE_V5 = "V5";
  static const String PROTOTYPE_V3 = "V3";
  static const String PROTOTYPE_LG19T = "SMA-LG19T";
  static const String PROTOTYPE_MATCH_S1 = "Match_S1";
  static const String PROTOTYPE_S03 = "SMA_S03";
  static const String PROTOTYPE_F2K = "F2K";
  static const String PROTOTYPE_W9 = "W9";
  static const String PROTOTYPE_R11S = "R11S";
  static const String PROTOTYPE_EXPLORER = "Explorer";
  static const String PROTOTYPE_NY58 = "NY58";
  static const String PROTOTYPE_F12 = "F12";
  static const String PROTOTYPE_F11 = "F11";
  static const String PROTOTYPE_F13A = "F13A";
  static const String PROTOTYPE_AM01 = "AM01";
  static const PROTOTYPE_F2R_DK = "F2R";
  static const PROTOTYPE_F1_DK = "F1";
  static const PROTOTYPE_S4 = "S4";
  static const PROTOTYPE_R6_PRO_DK = "R6_PRO_DK";
  static const PROTOTYPE_GB1 = "GB1";

  /// Goodix
  static const String PROTOTYPE_R3H = "R3H";
  static const String PROTOTYPE_R3Q = "R3Q";

  /// MTK
  static const String PROTOTYPE_F3 = "F3";
  static const String PROTOTYPE_M3 = "M3";
  static const String PROTOTYPE_M4 = "M4";
  static const String PROTOTYPE_M6 = "M6";
  static const String PROTOTYPE_M7 = "M7";
  static const String PROTOTYPE_R2 = "R2";
  static const String PROTOTYPE_M6C = "M6C";
  static const String PROTOTYPE_M7C = "M7C";
  static const String PROTOTYPE_M7S = "M7S";
  static const String PROTOTYPE_M4S = "M4S";
  static const String PROTOTYPE_M4C = "M4C";
  static const String PROTOTYPE_M5C = "M5C";

  /// JL
  static const String PROTOTYPE_R9J = "R9J";
  static const String PROTOTYPE_F13B = "F13B";
  static const PROTOTYPE_A7 = "A7";
  static const PROTOTYPE_A8 = "A8";
  static const PROTOTYPE_AM01J = "AM01J";
  static const PROTOTYPE_F17 = "F17";
  static const PROTOTYPE_AM02J = "AM02J";
  static const PROTOTYPE_HW01 = "HW01";
  static const PROTOTYPE_F12PRO = "F12Pro";
  static const PROTOTYPE_K18 = "K18";
  static const PROTOTYPE_AM05 = "AM05";
  static const PROTOTYPE_K30 = "K30";
  static const PROTOTYPE_FC1 = "FC1";
  static const PROTOTYPE_FC2 = "FC2";
  static const PROTOTYPE_FT5 = "FT5";
  static const PROTOTYPE_R16 = "R16";

  ///[mAGpsType]
  static const int AGPS_NONE = 0; // 无GPS芯片
  static const int AGPS_EPO = 1; // MTK EPO
  static const int AGPS_UBLOX = 2;
  static const int AGPS_AGNSS = 6; // 中科微
  static const int AGPS_EPO2 = 7; // Airoha EPO
  static const int AGPS_LTO = 8; // 博通 LTO

  ///[mWatchFaceType]
  static const int WATCH_0 = 0; // 不支持表盘
  static const int WATCH_1 = 1; // Q3表盘
  static const int WATCH_2 = 2; //MTK标准化表盘
  static const int WATCH_3 = 3; //Realtek bmp格式表盘 方形
  static const int WATCH_4 = 4; //MTK-小尺寸表盘 要求表盘文件不超过40K
  static const int WATCH_5 = 5; //MTK-表盘文件分辨率320x385
  static const int WATCH_6 = 6; //MTK-表盘文件分辨率320x363
  static const int WATCH_7 = 7; //Realtek bmp格式表盘 圆形
  static const int WATCH_8 = 8; //汇顶平台表盘
  static const int WATCH_9 = 9; //瑞昱R6,R8球拍屏，240x240
  static const int WATCH_10 = 10; //瑞昱240*280方形表盘BMP格式（单蓝牙）（中间件项目，表盘需字节对齐）
  static const int WATCH_11 = 11; //瑞昱bmp格式表盘, 圆形表盘  240*240，双模蓝牙
  static const int WATCH_12 = 12; //瑞昱bmp格式表盘，方形表盘 240*240 双模蓝牙
  static const int WATCH_13 = 13; //MTK 240x240-新表盘
  static const int WATCH_14 = 14; //瑞昱80*160方形表盘BMP格式
  static const int WATCH_15 = 15; //360x360 BMP 圆形-目前应用于瑞昱平台
  static const int WATCH_16 = 16; //瑞昱240*280方形表盘BMP格式（双蓝牙）
  static const int WATCH_17 = 17; //瑞昱 454x454 圆形 双蓝牙 R9 （中间件项目，表盘需字节对齐）
  static const int WATCH_18 = 18; //瑞昱 240x240 圆形 单蓝牙 GTM5（中间件项目，表盘需字节对齐）
  static const int WATCH_19 = 19; //瑞昱240*280方形表盘BMP格式（单蓝牙）
  static const int WATCH_20 = 20; //瑞昱240*280方形表盘BMP格式（双蓝牙）
  static const int WATCH_21 = 21; //瑞昱240*295方形表盘BMP格式（单蓝牙）（中间件项目，表盘需字节对齐）
  static const int WATCH_99 = 99; //返回99的直接从服务器获取

  static const int DIGITAL_POWER_VISIBLE = 0; //显示
  static const int DIGITAL_POWER_HIDE = 1;

  static const int ANTI_LOST_VISIBLE = 1; //防丢显示
  static const int ANTI_LOST_HIDE = 0; //防丢默认隐藏

  static const int SUPPORT_NEW_SLEEP_ALGORITHM_0 = 0; //新版睡眠算法-不支持-默认
  static const int SUPPORT_NEW_SLEEP_ALGORITHM_1 = 1; //新版睡眠算法

  static const int SUPPORT_DATE_FORMAT_1 = 1; //支持
  static const int SUPPORT_DATE_FORMAT_0 = 0; //默认不支持

  static const int SUPPORT_READ_DEVICE_INFO_1 = 1; //支持
  static const int SUPPORT_READ_DEVICE_INFO_0 = 0; //默认不支持

  static const int SUPPORT_TEMPERATURE_UNIT_1 = 1; //支持
  static const int SUPPORT_TEMPERATURE_UNIT_0 = 0; //默认不支持

  static const int SUPPORT_DRINK_WATER_1 = 1; //支持
  static const int SUPPORT_DRINK_WATER_0 = 0; //默认不支持

  static const int SUPPORT_CHANGE_CLASSIC_BLUETOOTH_STATE_1 = 1; //支持
  static const int SUPPORT_CHANGE_CLASSIC_BLUETOOTH_STATE_0 = 0; //默认不支持

  static const int SUPPORT_APP_SPORT_1 = 1; //支持
  static const int SUPPORT_APP_SPORT_0 = 0; //默认不支持

  static const int SUPPORT_BLOOD_OXYGEN_1 = 1; //支持
  static const int SUPPORT_BLOOD_OXYGEN_0 = 0; //默认不支持

  static const int SUPPORT_WASH_1 = 1; //支持
  static const int SUPPORT_WASH_0 = 0; //默认不支持

  static const int SUPPORT_REQUEST_REALTIME_WEATHER_1 = 1; //支持
  static const int SUPPORT_REQUEST_REALTIME_WEATHER_0 = 0; //默认不支持

  static const int SUPPORT_HID_1 = 1; //支持
  static const int SUPPORT_HID_0 = 0; //默认不支持

  static const int SUPPORT_IBEACON_SET_1 = 1; //支持
  static const int SUPPORT_IBEACON_SET_0 = 0; //默认不支持

  static const int SUPPORT_WATCHFACE_ID_1 = 1; //支持
  static const int SUPPORT_WATCHFACE_ID_0 = 0; //默认不支持

  static const int SUPPORT_JL_TRANSPORT_0 = 0; //默认不支持
  static const int SUPPORT_JL_TRANSPORT_1 = 1; //支持

  static const int SUPPORT_FIND_WATCH_0 = 0; //默认不支持
  static const int SUPPORT_FIND_WATCH_1 = 1; //不支持

  static const int SUPPORT_WORLD_CLOCK_0 = 0; //默认不支持
  static const int SUPPORT_WORLD_CLOCK_1 = 1; //支持

  static const int SUPPORT_STOCK_0 = 0; //默认不支持
  static const int SUPPORT_STOCK_1 = 1; //支持

  static const int SUPPORT_SMS_QUICK_REPLY_0 = 0; //默认不支持
  static const int SUPPORT_SMS_QUICK_REPLY_1 = 1; //支持

  static const int SUPPORT_NO_DISTURB_0 = 0; //默认不支持
  static const int SUPPORT_NO_DISTURB_1 = 1; //支持

  static const int SUPPORT_SET_WATCH_PASSWORD_0 = 0; //默认不支持
  static const int SUPPORT_SET_WATCH_PASSWORD_1 = 1; //支持

  static const int SUPPORT_REALTIME_MEASUREMENT_0 = 0; //默认不支持
  static const int SUPPORT_REALTIME_MEASUREMENT_1 = 1; //支持

  static const int SUPPORT_POWER_SAVE_MODE_0 = 0; //默认不支持
  static const int SUPPORT_POWER_SAVE_MODE_1 = 1; //支持

  static const int SUPPORT_LOVE_TAP_0 = 0; //默认不支持
  static const int SUPPORT_LOVE_TAP_1 = 1; //支持

  static const int SUPPORT_NEWS_FEED_0 = 0; //默认不支持
  static const int SUPPORT_NEWS_FEED_1 = 1; //支持

  static const int SUPPORT_MEDICATION_REMINDER_0 = 0; //默认不支持
  static const int SUPPORT_MEDICATION_REMINDER_1 = 1; //支持

  static const int SUPPORT_QRCODE_0 = 0; //默认不支持
  static const int SUPPORT_QRCODE_1 = 1; //支持

  static const int SUPPORT_WEATHER2_0 = 0; //默认不支持
  static const int SUPPORT_WEATHER2_1 = 1; //支持

  static const int SUPPORT_ALIPAY_0 = 0; //默认不支持
  static const int SUPPORT_ALIPAY_1 = 1; //支持

  static const int SUPPORT_STANDBY_SET_0 = 0; //默认不支持
  static const int SUPPORT_STANDBY_SET_1 = 1; //支持

  static const int SUPPORT_2D_ACCELERATION_0 = 0; //默认不支持
  static const int SUPPORT_2D_ACCELERATION_1 = 1; //支持

  static const int SUPPORT_TUYA_KEY_0 = 0; //默认不支持
  static const int SUPPORT_TUYA_KEY_1 = 1; //支持

  static const int SUPPORT_MEDICATION_ALARM_0 = 0; //默认不支持
  static const int SUPPORT_MEDICATION_ALARM_1 = 1; //支持

  static const int SUPPORT_READ_PACKAGE_STATUS_0 = 0; //默认不支持
  static const int SUPPORT_READ_PACKAGE_STATUS_1 = 1; //支持

  static const int SUPPORT_VOICE_0 = 0; //默认不支持
  static const int SUPPORT_VOICE_1 = 1; //支持

  static const int SUPPORT_NAVIGATION_0 = 0; //默认不支持
  static const int SUPPORT_NAVIGATION_1 = 1; //支持

  static const int SUPPORT_HR_WARN_SET_0 = 0; //默认不支持
  static const int SUPPORT_HR_WARN_SET_1 = 1; //支持

  static const int SUPPORT_MUSIC_TRANSFER_SET_0 = 0; //默认不支持
  static const int SUPPORT_MUSIC_TRANSFER_SET_1 = 1; //支持

  static const SUPPORT_NO_DISTURB2_0 = 0;//默认不支持
  static const SUPPORT_NO_DISTURB2_1 = 1;//支持

  static const SUPPORT_SOS_SET_0 = 0;//默认不支持
  static const SUPPORT_SOS_SET_1 = 1;//支持

  static const SUPPORT_READ_LANGUAGES_0 = 0;//默认不支持
  static const SUPPORT_READ_LANGUAGES_1 = 1;//支持

  static const SUPPORT_GIRLCARE_REMINDER_0 = 0;//默认不支持
  static const SUPPORT_GIRLCARE_REMINDER_1 = 1;//支持

  static const SUPPORT_GAME_TIME_REMINDER_0 = 0;//默认不支持
  static const SUPPORT_GAME_TIME_REMINDER_1 = 1;//支持

  static const SUPPORT_DEVICE_SPORT_DATA_1 = 1;//支持
  static const SUPPORT_DEVICE_SPORT_DATA_0 = 0;//默认不支持

  static const SUPPORT_EBOOK_TRANSFER_0 = 0;//默认不支持
  static const SUPPORT_EBOOK_TRANSFER_1 = 1;//支持

  static const SUPPORT_DOUBLE_SCREEN_1 = 1; //支持
  static const SUPPORT_DOUBLE_SCREEN_0 = 0; //默认不支持

  static const SUPPORT_CUSTOM_LOGO_1 = 1; //支持
  static const SUPPORT_CUSTOM_LOGO_0 = 0; //默认不支持

  static const SUPPORT_PRESSURE_TIMING_MEASUREMENT_1 = 1; //支持
  static const SUPPORT_PRESSURE_TIMING_MEASUREMENT_0 = 0; //默认不支持

  static const SUPPORT_TIMER_STANDBYSET_1 = 1; //支持
  static const SUPPORT_TIMER_STANDBYSET_0 = 0; //默认不支持

  static const SUPPORT_FALL_SET_0 = 0; //默认不支持
  static const SUPPORT_FALL_SET_1 = 1; //支持

  static const SUPPORT_WALK_BIKE_0 = 0; //默认不支持
  static const SUPPORT_WALK_BIKE_1 = 1; //支持

  static const SUPPORT_CONNECT_REMINDER_0 = 0; //默认不支持
  static const SUPPORT_CONNECT_REMINDER_1 = 1; //支持

  static const SUPPORT_SDCARD_INFO_0 = 0; //默认不支持
  static const SUPPORT_SDCARD_INFO_1 = 1; //支持

  static const SUPPORT_INCOMING_CALL_RING_0 = 0; //默认不支持
  static const SUPPORT_INCOMING_CALL_RING_1 = 1; //支持

  static const SUPPORT_NOTIFICATION_LIGHT_SCREEN_SET_0 = 0; //默认不支持
  static const SUPPORT_NOTIFICATION_LIGHT_SCREEN_SET_1 = 1; //支持

  static const SUPPORT_BLOOD_PRESSURE_CALIBRATION_0 = 0; //默认不支持
  static const SUPPORT_BLOOD_PRESSURE_CALIBRATION_1 = 1; //支持

  static const SUPPORT_OTA_FILE_0 = 0; //默认不支持
  static const SUPPORT_OTA_FILE_1 = 1; //支持

  int mId = 0;

  ///设备支持读取的数据列表。
  List<int> mDataKeys = [];

  ///设备蓝牙名。
  String? mBleName;

  ///设备蓝牙4.0地址。
  String? mBleAddress;

  ///芯片平台，[PLATFORM_NORDIC]、[PLATFORM_REALTEK]、[PLATFORM_MTK]或[PLATFORM_GOODIX]。
  String? mPlatform;

  ///设备原型，代表是基于哪款设备开发，[PROTOTYPE_10G]、[PROTOTYPE_R4]或[PROTOTYPE_R5]等。
  String? mPrototype;

  ///固件标记，固件那边所说的制造商，但严格来说，制造商表述并不恰当，且避免与后台数据结构中的分销商语义冲突，
  ///因为其仅仅用来区分固件，所以命名为FirmwareFlag，与[mBleName]一起确定唯一固件。
  String? mFirmwareFlag;

  ///aGps文件类型，不同读GPS芯片需要下载不同的aGps文件，[AGPS_EPO]、[AGPS_UBLOX]或[AGPS_AGNSS]等，
  ///如果为0，代表不支持GPS。
  int mAGpsType = 0;

  ///发送[BleCommand.IO]的Buffer大小，见[BleConnector.sendStream]。
  int mIOBufferSize = 0;

  ///表盘类型，[WATCH_0]、[WATCH_1]或[WATCH_2]。
  int mWatchFaceType = 0;

  ///设备蓝牙3.0地址。
  String? mClassicAddress;

  ///是否显示数字电量  [DIGITAL_POWER_VISIBLE] [DIGITAL_POWER_HIDE]
  int mHideDigitalPower = 0;

  ///是否显示防丢开关  [ANTI_LOST_VISIBLE] [ANTI_LOST_HIDE]
  int mShowAntiLostSwitch = 0;

  ///支持的睡眠算法类型  [SUPPORT_NEW_SLEEP_ALGORITHM_0] [SUPPORT_NEW_SLEEP_ALGORITHM_1]
  int mSleepAlgorithmType = 0;

  ///是否支持日期格式设置 [SUPPORT_DATE_FORMAT_0] [SUPPORT_DATE_FORMAT_1]
  int mSupportDateFormatSet = 0;

  ///是否支持读取设备信息。在之前, APP只能在绑定设备时被动接收到设备信息, 导致如果固件升级时修改了设备信息，APP不重新绑定
  ///就获取不了新的设备信息。加上该标记后, APP读取固件版本时, 如果发现与之前的版本不一致, 就主动更新下设备信息
  int mSupportReadDeviceInfo = 0;

  ///是否支持温度单位设置 [SUPPORT_TEMPERATURE_UNIT_0] [SUPPORT_TEMPERATURE_UNIT_1]
  int mSupportTemperatureUnitSet = 0;

  ///是否支持喝水提醒的设置 [SUPPORT_DRINK_WATER_0] [SUPPORT_DRINK_WATER_1]
  int mSupportDrinkWaterSet = 0;

  ///是否支持切换经典蓝牙开关指令 [SUPPORT_CHANGE_CLASSIC_BLUETOOTH_STATE_0] [SUPPORT_CHANGE_CLASSIC_BLUETOOTH_STATE_1]
  int mSupportChangeClassicBluetoothState = 0;

  ///是否支持app运动指令 [SUPPORT_APP_SPORT_0] [SUPPORT_APP_SPORT_1]
  int mSupportAppSport = 0;

  ///是否支持血氧的设置 [SUPPORT_BLOOD_OXYGEN_0] [SUPPORT_BLOOD_OXYGEN_1]
  int mSupportBloodOxyGenSet = 0;

  ///是否支持洗手提醒的设置 [SUPPORT_WASH_0] [SUPPORT_WASH_1]
  int mSupportWashSet = 0;

  ///是否支持按需获取天气 [SUPPORT_REQUEST_REALTIME_WEATHER_0] [SUPPORT_REQUEST_REALTIME_WEATHER_1]
  int mSupportRequestRealtimeWeather = 0;

  ///是否支持HID [SUPPORT_HID_0] [SUPPORT_HID_1]
  int mSupportHID = 0;

  ///是否支持iBeacon设置 [SUPPORT_IBEACON_SET_0] [SUPPORT_IBEACON_SET_1]
  int mSupportIBeaconSet = 0;

  ///是否支持设置表盘id [SUPPORT_WATCHFACE_ID_0] [SUPPORT_WATCHFACE_ID_1]
  int mSupportWatchFaceId = 0;

  ///是否支持新的传输方式，目前只有ios用到，这里安卓只占个位
  int mSupportNewTransportMode = 0;

  ///是否支持杰里sdk传输 [SUPPORT_JL_TRANSPORT_0] [SUPPORT_JL_TRANSPORT_1]
  int mSupportJLTransport = 0;

  ///是否支持找手表 [SUPPORT_FIND_WATCH_0] [SUPPORT_FIND_WATCH_1]
  int mSupportFindWatch = 0;

  ///是否支持世界时钟 [SUPPORT_WORLD_CLOCK_0] [SUPPORT_WORLD_CLOCK_1]
  int mSupportWorldClock = 0;

  ///是否支持股票 [SUPPORT_STOCK_0] [SUPPORT_STOCK_1]
  int mSupportStock = 0;

  ///是否短信快捷回复 [SUPPORT_SMS_QUICK_REPLY_0] [SUPPORT_SMS_QUICK_REPLY_1]
  int mSupportSMSQuickReply = 0;

  ///是否支持App勿扰时间段的设置 [SUPPORT_NO_DISTURB_0] [SUPPORT_NO_DISTURB_1]
  int mSupportNoDisturbSet = 0;

  ///是否支持手表密码锁 [SUPPORT_SET_WATCH_PASSWORD_0] [SUPPORT_SET_WATCH_PASSWORD_1]
  int mSupportSetWatchPassword = 0;

  ///是否支持手机控制手表测量心率，血氧，血压 [SUPPORT_REALTIME_MEASUREMENT_0] [SUPPORT_REALTIME_MEASUREMENT_1]
  int mSupportRealTimeMeasurement = 0;

  ///是否支持省电模式 [SUPPORT_POWER_SAVE_MODE_0] [SUPPORT_POWER_SAVE_MODE_1]
  int mSupportPowerSaveMode = 0;

  ///是否支持LoveTap [SUPPORT_LOVE_TAP_0] [SUPPORT_LOVE_TAP_1]
  var mSupportLoveTap = 0;

  ///是否支持Newsfeed [SUPPORT_NEWS_FEED_0] [SUPPORT_NEWS_FEED_1]
  var mSupportNewsfeed = 0;

  ///是否支持吃药提醒 [SUPPORT_MEDICATION_REMINDER_0] [SUPPORT_MEDICATION_REMINDER_1]
  var mSupportMedicationReminder = 0;

  ///是否支持同步二维码 [SUPPORT_QRCODE_0] [SUPPORT_QRCODE_1]
  var mSupportQrcode = 0;

  ///是否支持新的天气协议（支持7天) [SUPPORT_WEATHER2_0] [SUPPORT_WEATHER2_1]
  var mSupportWeather2 = 0;

  ///是否支持支付宝 [SUPPORT_ALIPAY_0] [SUPPORT_ALIPAY_1]
  var mSupportAlipay = 0;

  ///是否支持待机设置 [SUPPORT_STANDBY_SET_0] [SUPPORT_STANDBY_SET_1]
  var mSupportStandbySet = 0;

  ///是否支持2d加速 [SUPPORT_2D_ACCELERATION_0] [SUPPORT_2D_ACCELERATION_1]
  var mSupport2DAcceleration = 0;

  ///是否支持涂鸦授权码修改 [SUPPORT_TUYA_KEY_0] [SUPPORT_TUYA_KEY_1]
  var mSupportTuyaKey = 0;

  ///是否支持吃药闹钟 [SUPPORT_MEDICATION_ALARM_0] [SUPPORT_MEDICATION_ALARM_1]
  var mSupportMedicationAlarm = 0;

  ///是否支持读取获取手表字库/UI/语言包状态信息 [SUPPORT_READ_PACKAGE_STATUS_0] [SUPPORT_READ_PACKAGE_STATUS_1]
  var mSupportReadPackageStatus = 0;

  ///支持的联系人数量，如果返回0，默认20条；返回大于0，则size = value * 10
  var mSupportContactSize = 0;

  ///是否支持语音功能 [SUPPORT_VOICE_0] [SUPPORT_VOICE_1]
  var mSupportVoice = 0;

  ///是否支持导航功能 [SUPPORT_NAVIGATION_0] [SUPPORT_NAVIGATION_1]
  var mSupportNavigation = 0;

  ///是否支持心率预警设置 [SUPPORT_HR_WARN_SET_0] [SUPPORT_HR_WARN_SET_1]
  var mSupportHrWarnSet = 0;

  ///是否支持音乐传输 [SUPPORT_MUSIC_TRANSFER_SET_0] [SUPPORT_MUSIC_TRANSFER_SET_1]
  var mSupportMusicTransfer = 0;

  /// 是否支持App勿扰时间段的设置和总开关设置 [SUPPORT_NO_DISTURB2_0] [SUPPORT_NO_DISTURB2_1]
  var mSupportNoDisturbSet2 = 0;

  /// 是否支持SOS设置 [SUPPORT_SOS_SET_0] [SUPPORT_SOS_SET_1]
  var mSupportSOSSet = 0;

  /// 是否支持获取语言列表 [SUPPORT_READ_LANGUAGES_0] [SUPPORT_READ_LANGUAGES_1]
  var mSupportReadLanguages = 0;

  /// 是否支持女性生理期提醒设置 [SUPPORT_GIRLCARE_REMINDER_0] [SUPPORT_GIRLCARE_REMINDER_1]
  var mSupportGirlCareReminder = 0;

  /// 是否支持信息提醒APP开关设置2，目前只有ios用到，这里安卓只占个位
  var mSupportAppPushSwitch = 0;

  /// 收款码二维码数量，0表示不支持，需要使用 [BleKey.QRCODE2]
  var mSupportReceiptCodeSize = 0;

  /// 是否支持游戏时长提醒设置 [SUPPORT_GAME_TIME_REMINDER_0] [SUPPORT_GAME_TIME_REMINDER_1]
  var mSupportGameTimeReminder = 0;

  /// 我的名片二维码数量，0表示不支持，需要使用 [BleKey.QRCODE2]
  var mSupportMyCardCodeSize = 0;

  /// 是否支持实时传输运动数据给APP [SUPPORT_DEVICE_SPORT_DATA_0] [SUPPORT_DEVICE_SPORT_DATA_1]
  var mSupportDeviceSportData = 0;

  /// 是否支持电子书传输 [SUPPORT_EBOOK_TRANSFER_0] [SUPPORT_EBOOK_TRANSFER_1]
  var mSupportEbookTransfer = 0;

  /// 是否支持双击亮屏 [SUPPORT_DOUBLE_SCREEN_0] [SUPPORT_DOUBLE_SCREEN_1]
  var mSupportDoubleScreen = 0;

  /// 是否支持自定义开机LOGO [SUPPORT_CUSTOM_LOGO_0] [SUPPORT_CUSTOM_LOGO_1]
  var mSupportCustomLogo = 0;

  /// 是否支持app设置压力定时测量 [SUPPORT_PRESSURE_TIMING_MEASUREMENT_0] [SUPPORT_PRESSURE_TIMING_MEASUREMENT_1]
  var mSupportPressureTimingMeasurement = 0;

  /// 是否支持定时待机表盘设置 [SUPPORT_TIMER_STANDBYSET_0] [SUPPORT_TIMER_STANDBYSET_1]
  var mSupportTimerStandbySet = 0;

  /// 是否支持SOS设置 [SUPPORT_SOS_SET_0] [SUPPORT_SOS_SET_1]
  /// 后续判读是否支持支持SOS设置使用这个，用法不变
  var mSupportSOSSet2 = 0;

  /// 是否支持跌落设置 [SUPPORT_FALL_SET_0] [SUPPORT_FALL_SET_1]
  var mSupportFallSet = 0;

  /// 是否支持骑行和步行 [SUPPORT_WALK_BIKE_0] [SUPPORT_WALK_BIKE_1]
  var mSupportWalkAndBike = 0;

  /// 是否支持连接提醒，目前是多设备切换后连接上时发出提醒 [SUPPORT_CONNECT_REMINDER_0] [SUPPORT_CONNECT_REMINDER_1]
  var mSupportConnectReminder = 0;

  /// 是否支持读取SDCard信息 [SUPPORT_SDCARD_INFO_0] [SUPPORT_SDCARD_INFO_1]
  var mSupportSDCardInfo = 0;

  /// 是否支持来电铃声设置[SUPPORT_INCOMING_CALL_RING_0] [SUPPORT_INCOMING_CALL_RING_1]
  var mSupportIncomingCallRing = 0;

  /// 是否支持消息亮屏提醒设置[SUPPORT_NOTIFICATION_LIGHT_SCREEN_SET_0] [SUPPORT_NOTIFICATION_LIGHT_SCREEN_SET_1]
  var mSupportNotificationLightScreenSet = 0;

  /// 是否支持血压标定[SUPPORT_BLOOD_PRESSURE_CALIBRATION_0] [SUPPORT_BLOOD_PRESSURE_CALIBRATION_1]
  var mSupportBloodPressureCalibration = 0;

  /// 是否支持传输ota文件，目前双备份设备ota使用[BleKey.OTA_FILE]
  /// [SUPPORT_OTA_FILE_0] [SUPPORT_OTA_FILE_1]
  var mSupportOTAFile = 0;

  /// 是否支持传输GPS 固件文件  [BleKey.GPS_FIRMWARE_FILE]
  ///  0:不支持;   1支持
  var mSupportGPSFirmwareFile = 0;

  BleDeviceInfo();

  @override
  String toString() {
    return "BleDeviceInfo(mDataKeys=${mDataKeys.map((e) => BleKey.of(e))}, mBleName='$mBleName', mBleAddress='$mBleAddress', mPlatform='$mPlatform', "
        "mPrototype='$mPrototype', mFirmwareFlag='$mFirmwareFlag', mAGpsType=$mAGpsType, mIOBufferSize=$mIOBufferSize, mWatchFaceType=$mWatchFaceType, mClassicAddress='$mClassicAddress', "
        "mHideDigitalPower=$mHideDigitalPower, mShowAntiLostSwitch=$mShowAntiLostSwitch, mSleepAlgorithmType=$mSleepAlgorithmType, mSupportDateFormatSet=$mSupportDateFormatSet, "
        "mSupportReadDeviceInfo=$mSupportReadDeviceInfo, mSupportTemperatureUnitSet=$mSupportTemperatureUnitSet, mSupportDrinkWaterSet=$mSupportDrinkWaterSet, "
        "mSupportChangeClassicBluetoothState=$mSupportChangeClassicBluetoothState, mSupportAppSport=$mSupportAppSport, mSupportBloodOxyGenSet=$mSupportBloodOxyGenSet, "
        "mSupportWashSet=$mSupportWashSet, mSupportRequestRealtimeWeather=$mSupportRequestRealtimeWeather, mSupportHID=$mSupportHID, mSupportIBeaconSet=$mSupportIBeaconSet, "
        "mSupportWatchFaceId=$mSupportWatchFaceId, mSupportNewTransportMode=$mSupportNewTransportMode, mSupportJLTransport=$mSupportJLTransport, mSupportFindWatch=$mSupportFindWatch, "
        "mSupportWorldClock=$mSupportWorldClock, mSupportStock=$mSupportStock, mSupportSMSQuickReply=$mSupportSMSQuickReply, mSupportNoDisturbSet=$mSupportNoDisturbSet, "
        "mSupportSetWatchPassword=$mSupportSetWatchPassword, mSupportRealTimeMeasurement=$mSupportRealTimeMeasurement, mSupportPowerSaveMode=$mSupportPowerSaveMode, mSupportLoveTap=$mSupportLoveTap, "
        "mSupportNewsfeed=$mSupportNewsfeed, mSupportMedicationReminder=$mSupportMedicationReminder, mSupportQrcode=$mSupportQrcode, mSupportWeather2=$mSupportWeather2, mSupportAlipay=$mSupportAlipay, "
        "mSupportStandbySet=$mSupportStandbySet, mSupport2DAcceleration=$mSupport2DAcceleration, mSupportTuyaKey=$mSupportTuyaKey, mSupportMedicationAlarm=$mSupportMedicationAlarm, "
        "mSupportReadPackageStatus=$mSupportReadPackageStatus, mSupportContactSize=$mSupportContactSize, mSupportVoice=$mSupportVoice, mSupportNavigation=$mSupportNavigation, "
        "mSupportHrWarnSet=$mSupportHrWarnSet, mSupportMusicTransfer=$mSupportMusicTransfer, mSupportNoDisturbSet2=$mSupportNoDisturbSet2, "
        "mSupportSOSSet=$mSupportSOSSet, mSupportReadLanguages=$mSupportReadLanguages, mSupportGirlCareReminder=$mSupportGirlCareReminder, mSupportGameTimeReminder=$mSupportGameTimeReminder, "
        "mSupportAppPushSwitch=$mSupportAppPushSwitch, mSupportReceiptCodeSize=$mSupportReceiptCodeSize, mSupportGameTimeReminder=$mSupportGameTimeReminder, "
        "mSupportMyCardCodeSize=$mSupportMyCardCodeSize, mSupportDeviceSportData=$mSupportDeviceSportData, "
        "mSupportEbookTransfer=$mSupportEbookTransfer, mSupportDoubleScreen=$mSupportDoubleScreen, mSupportCustomLogo=$mSupportCustomLogo, "
        "mSupportPressureTimingMeasurement=$mSupportPressureTimingMeasurement, mSupportTimerStandbySet=$mSupportTimerStandbySet, "
        "mSupportSOSSet2=$mSupportSOSSet2, mSupportFallSet=$mSupportFallSet, mSupportWalkAndBike=$mSupportWalkAndBike, mSupportConnectReminder=$mSupportConnectReminder, "
        "mSupportSDCardInfo=$mSupportSDCardInfo, mSupportIncomingCallRing=$mSupportIncomingCallRing, mSupportNotificationLightScreenSet=$mSupportNotificationLightScreenSet, "
        "mSupportBloodPressureCalibration=$mSupportBloodPressureCalibration, mSupportOTAFile=$mSupportOTAFile, mSupportGPSFirmwareFile:$mSupportGPSFirmwareFile)";
  }

  factory BleDeviceInfo.fromJson(Map map) {
    BleDeviceInfo deviceInfo = BleDeviceInfo();
    deviceInfo.mId = map["mId"];
    deviceInfo.mDataKeys = map.listValue<int>("mDataKeys")!;
    deviceInfo.mBleName = map["mBleName"];
    deviceInfo.mBleAddress = map["mBleAddress"];
    deviceInfo.mPlatform = map["mPlatform"];
    deviceInfo.mPrototype = map["mPrototype"];
    deviceInfo.mFirmwareFlag = map["mFirmwareFlag"];
    deviceInfo.mAGpsType = map["mAGpsType"] ?? 0;
    deviceInfo.mIOBufferSize = map["mIOBufferSize"] ?? 0;
    deviceInfo.mWatchFaceType = map["mWatchFaceType"] ?? 0;
    deviceInfo.mClassicAddress = map["mClassicAddress"] ?? '';
    deviceInfo.mHideDigitalPower = map["mHideDigitalPower"] ?? 0;
    deviceInfo.mShowAntiLostSwitch = map["mShowAntiLostSwitch"] ?? 0;
    deviceInfo.mSleepAlgorithmType = map["mSleepAlgorithmType"] ?? 0;
    deviceInfo.mSupportDateFormatSet = map["mSupportDateFormatSet"] ?? 0;
    deviceInfo.mSupportReadDeviceInfo = map["mSupportReadDeviceInfo"] ?? 0;
    deviceInfo.mSupportTemperatureUnitSet = map["mSupportTemperatureUnitSet"] ?? 0;
    deviceInfo.mSupportDrinkWaterSet = map["mSupportDrinkWaterSet"] ?? 0;
    deviceInfo.mSupportChangeClassicBluetoothState =
        map["mSupportChangeClassicBluetoothState"] ?? 0;
    deviceInfo.mSupportAppSport = map["mSupportAppSport"] ?? 0;
    deviceInfo.mSupportBloodOxyGenSet = map["mSupportBloodOxyGenSet"] ?? 0;
    deviceInfo.mSupportWashSet = map["mSupportWashSet"] ?? 0;
    deviceInfo.mSupportRequestRealtimeWeather =
        map["mSupportRequestRealtimeWeather"] ?? 0;
    deviceInfo.mSupportHID = map["mSupportHID"] ?? 0;
    deviceInfo.mSupportIBeaconSet = map["mSupportIBeaconSet"] ?? 0;
    deviceInfo.mSupportWatchFaceId = map["mSupportWatchFaceId"] ?? 0;
    deviceInfo.mSupportNewTransportMode = map["mSupportNewTransportMode"] ?? 0;
    deviceInfo.mSupportJLTransport = map["mSupportJLTransport"] ?? 0;
    deviceInfo.mSupportFindWatch = map["mSupportFindWatch"] ?? 0;
    deviceInfo.mSupportWorldClock = map["mSupportWorldClock"] ?? 0;
    deviceInfo.mSupportStock = map["mSupportStock"] ?? 0;
    deviceInfo.mSupportSMSQuickReply = map["mSupportSMSQuickReply"] ?? 0;
    deviceInfo.mSupportNoDisturbSet = map["mSupportNoDisturbSet"] ?? 0;
    deviceInfo.mSupportSetWatchPassword = map["mSupportSetWatchPassword"] ?? 0;
    deviceInfo.mSupportRealTimeMeasurement = map["mSupportRealTimeMeasurement"] ?? 0;
    deviceInfo.mSupportPowerSaveMode = map["mSupportPowerSaveMode"] ?? 0;
    deviceInfo.mSupportLoveTap = map["mSupportLoveTap"] ?? 0;
    deviceInfo.mSupportNewsfeed = map["mSupportNewsfeed"] ?? 0;
    deviceInfo.mSupportMedicationReminder = map["mSupportMedicationReminder"] ?? 0;
    deviceInfo.mSupportQrcode = map["mSupportQrcode"] ?? 0;
    deviceInfo.mSupportWeather2 = map["mSupportWeather2"] ?? 0;
    deviceInfo.mSupportAlipay = map["mSupportAlipay"] ?? 0;
    deviceInfo.mSupportStandbySet = map["mSupportStandbySet"] ?? 0;
    deviceInfo.mSupport2DAcceleration = map["mSupport2DAcceleration"] ?? 0;
    deviceInfo.mSupportTuyaKey = map["mSupportTuyaKey"] ?? 0;
    deviceInfo.mSupportMedicationAlarm = map["mSupportMedicationAlarm"] ?? 0;
    deviceInfo.mSupportReadPackageStatus = map["mSupportReadPackageStatus"] ?? 0;
    deviceInfo.mSupportContactSize = map["mSupportContactSize"] ?? 0;
    deviceInfo.mSupportVoice = map["mSupportVoice"] ?? 0;
    deviceInfo.mSupportNavigation = map["mSupportNavigation"] ?? 0;
    deviceInfo.mSupportHrWarnSet = map["mSupportHrWarnSet"] ?? 0;
    deviceInfo.mSupportMusicTransfer = map["mSupportMusicTransfer"] ?? 0;
    deviceInfo.mSupportNoDisturbSet2 = map["mSupportNoDisturbSet2"] ?? 0;
    deviceInfo.mSupportSOSSet = map["mSupportSOSSet"] ?? 0;
    deviceInfo.mSupportReadLanguages = map["mSupportReadLanguages"] ?? 0;
    deviceInfo.mSupportGirlCareReminder = map["mSupportGirlCareReminder"] ?? 0;
    deviceInfo.mSupportAppPushSwitch = map["mSupportAppPushSwitch"] ?? 0;
    deviceInfo.mSupportReceiptCodeSize = map["mSupportReceiptCodeSize"] ?? 0;
    deviceInfo.mSupportGameTimeReminder = map["mSupportGameTimeReminder"] ?? 0;
    deviceInfo.mSupportMyCardCodeSize = map["mSupportMyCardCodeSize"] ?? 0;
    deviceInfo.mSupportDeviceSportData = map["mSupportDeviceSportData"] ?? 0;
    deviceInfo.mSupportEbookTransfer = map["mSupportEbookTransfer"] ?? 0;
    deviceInfo.mSupportDoubleScreen = map["mSupportDoubleScreen"] ?? 0;
    deviceInfo.mSupportCustomLogo = map["mSupportCustomLogo"] ?? 0;
    deviceInfo.mSupportPressureTimingMeasurement = map["mSupportPressureTimingMeasurement"] ?? 0;
    deviceInfo.mSupportTimerStandbySet = map["mSupportTimerStandbySet"] ?? 0;
    deviceInfo.mSupportSOSSet2 = map["mSupportSOSSet2"] ?? 0;
    deviceInfo.mSupportFallSet = map["mSupportFallSet"] ?? 0;
    deviceInfo.mSupportWalkAndBike = map["mSupportWalkAndBike"] ?? 0;
    deviceInfo.mSupportConnectReminder = map["mSupportConnectReminder"] ?? 0;
    deviceInfo.mSupportSDCardInfo = map["mSupportSDCardInfo"] ?? 0;
    deviceInfo.mSupportIncomingCallRing = map["mSupportIncomingCallRing"] ?? 0;
    deviceInfo.mSupportNotificationLightScreenSet = map["mSupportNotificationLightScreenSet"] ?? 0;
    deviceInfo.mSupportBloodPressureCalibration = map["mSupportBloodPressureCalibration"] ?? 0;
    deviceInfo.mSupportOTAFile = map["mSupportOTAFile"] ?? 0;
    deviceInfo.mSupportGPSFirmwareFile = map['mSupportGPSFirmwareFile'] ?? 0;
    return deviceInfo;
  }
}
