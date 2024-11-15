import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import '../main.dart';

class BleKeyFlagPage extends StatefulWidget {
  final BleKey mBleKey;

  const BleKeyFlagPage(this.mBleKey);

  @override
  State<BleKeyFlagPage> createState() => _BleKeyFlagPageState();
}

class _BleKeyFlagPageState extends State<BleKeyFlagPage> with BleHandleCallback {

  bool started = false;

  // define the handler for ui
  void onData(NotificationEvent event) {
    BleLog.d(event.toString());

    // your filter rule
    if (event.packageName == BleNotification.QQ ||
        event.packageName == BleNotification.WE_CHAT ||
        event.packageName == BleNotification.WHATS_APP) {
      BleNotification notification = BleNotification();
      notification.mCategory = BleNotification.CATEGORY_MESSAGE;
      notification.mTime = DateTime.now().millisecondsSinceEpoch;
      notification.mPackage = event.packageName!;
      notification.mTitle = event.title ?? "";
      notification.mContent = event.text ?? "";
      BleConnector.getInstance.sendObject(BleKey.NOTIFICATION, BleKeyFlag.UPDATE,notification);
    }
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    // register you event handler in the ui logic.
    NotificationsListener.receivePort?.listen((evt) => onData(evt));
  }

  void startListening() async {
    BleLog.d("start listening");
    var hasPermission = await NotificationsListener.hasPermission;
    if (!hasPermission!) {
      BleLog.d("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!isR!) {
      await NotificationsListener.startService();
    }

    setState(() => started = true);
  }

  @override
  void initState() {
    super.initState();
    BleConnector.getInstance.addHandleCallback(this);
  }

  @override
  void dispose() {
    BleConnector.getInstance.removeHandleCallback(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BleKeyFlag"),
        ),
        body: ListView.builder(
            itemCount: widget.mBleKey.getBleKeyFlags().length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(widget.mBleKey.getBleKeyFlags()[i].toString()),
                onTap: () {
                  _onItemClick(widget.mBleKey, widget.mBleKey.getBleKeyFlags()[i]);
                },
              );
            }));
  }

  void _unbindDone(){
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
  }

  Future<void> _onItemClick(BleKey bleKey, BleKeyFlag bleKeyFlag) async {
    switch (bleKey) {
      //UPDATE
      case BleKey.OTA:

        // 获取设备的uuid字符串, 示例代码
        // Get the uuid string of the device, sample code
        //var uuidString = await BleConnector.getInstance.onRetrieveConnectedDeviceUUID();
        //BleLog.d('The currently connected device UUID, uuidString: $uuidString');

        Navigator.of(context).popAndPushNamed('/ota_page', arguments: null);
        break;
      case BleKey.XMODEM:
        BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        break;
      //SET
      case BleKey.TIME:
      case BleKey.TIME_ZONE:
      case BleKey.POWER:
      case BleKey.FIRMWARE_VERSION:
      case BleKey.BLE_ADDRESS:
      case BleKey.UI_PACK_VERSION:
      case BleKey.LANGUAGE_PACK_VERSION:
        if (await BleConnector.getInstance.isAvailable()) {
          // Connection available, execute instructions
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        } else {
          showToast("isAvailable == false");
        }
        break;
      case BleKey.USER_PROFILE:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置用户信息
          BleUserProfile bleUserProfile = BleUserProfile();
          bleUserProfile.mUnit = BleUserProfile.METRIC;
          bleUserProfile.mGender = BleUserProfile.FEMALE;
          bleUserProfile.mAge = 20;
          bleUserProfile.mHeight = 170;
          bleUserProfile.mWeight = 60;
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, bleUserProfile);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.TEMPERATURE_UNIT:
        // 设置温度单位 0:°C  1:°F  == Set temperature unit 0: Celsius °C 1: Fahrenheit °F
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置温度单位
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 1);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          // 读取温度单位
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.DATE_FORMAT:
      /**
       * 日期格式设置
       * Date format Setting
       *
       * value 0 = "年/月/日"   "YYYY/MM/dd"
       * value 1 = "日/月/年"   "dd/MM/YYYY""
       * value 2 = "月/日/年"   "MM/dd/YYYY"
       */

        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置日期格式
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 2);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          // 读取日期格式设置
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.POWER_SAVE_MODE:
      // 0: close; 1: open
        BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 1);
        break;
      case BleKey.STEP_GOAL:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置目标步数
          BleConnector.getInstance.sendInt32(bleKey, bleKeyFlag, 20);
        }
        break;
      case BleKey.FIND_WATCH:
      // 0: close; 1: open
        BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 1);
        break;
      case BleKey.CALORIES_GOAL:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 1 cal
          BleConnector.getInstance.sendInt32(bleKey, bleKeyFlag, 2 * 1000);//2kcal
        }
        break;
      case BleKey.DISTANCE_GOAL:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 1 m
          BleConnector.getInstance.sendInt32(bleKey, bleKeyFlag, 2 * 1000);//2km
        }
        break;
      case BleKey.SLEEP_GOAL:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 1 minu
          BleConnector.getInstance.sendInt16(bleKey, bleKeyFlag, 7 * 60);//8hour
        }
        break;
      case BleKey.BACK_LIGHT:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置背光时长
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 6); // 0 is off, or 5 ~ 20
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.SEDENTARINESS:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置久坐
          BleSedentarinessSettings bleSedentariness = BleSedentarinessSettings();
          bleSedentariness.mEnabled = 1;
          // Monday ~ Saturday
          bleSedentariness.mRepeat = BleRepeat.MONDAY | BleRepeat.TUESDAY | BleRepeat.WEDNESDAY | BleRepeat.THURSDAY | BleRepeat.FRIDAY | BleRepeat.SATURDAY;
          bleSedentariness.mStartHour = 1;
          bleSedentariness.mEndHour = 22;
          bleSedentariness.mInterval = 60;
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, bleSedentariness);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.NO_DISTURB_RANGE:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置勿扰
          BleNoDisturbSettings noDisturb = BleNoDisturbSettings();
          noDisturb.mBleTimeRange1 = BleTimeRange(1, 2, 0, 18, 0);

          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, noDisturb);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.VIBRATION:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置震动次数
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 3); // 0~10, 0 is off
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.GESTURE_WAKE:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置抬手亮
          BleGestureWake gestureWake = BleGestureWake();
          gestureWake.mBleTimeRange = BleTimeRange(1, 8, 0, 22, 0);
          BleConnector.getInstance.sendObject(
              bleKey, bleKeyFlag,
              gestureWake
          );
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.HOUR_SYSTEM:
        // 设置小时制
        // 切换, 0: 24-hourly; 1: 12-hourly
        BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 0);
        break;
      case BleKey.LANGUAGE:
        // 设置设备语言
        BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, Languages.DEFAULT_CODE);
        break;
      case BleKey.ALARM:
        if (bleKeyFlag == BleKeyFlag.CREATE) {
          BleAlarm alarm = BleAlarm();
          alarm.mEnabled = 1;
          alarm.mRepeat = BleRepeat.EVERYDAY;
          alarm.mYear = 2022;
          alarm.mMonth = 1;
          alarm.mDay = 1;
          alarm.mHour = 1;
          alarm.mMinute = 1;
          alarm.mTag = "Tag";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, alarm);
        } else if (bleKeyFlag == BleKeyFlag.DELETE) {
          int id = 123;
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, id);
        } else if (bleKeyFlag == BleKeyFlag.UPDATE) {
          BleAlarm alarm = BleAlarm();
          alarm.mId = 123;
          alarm.mEnabled = 1;
          alarm.mRepeat = BleRepeat.EVERYDAY;
          alarm.mYear = 2022;
          alarm.mMonth = 1;
          alarm.mDay = 1;
          alarm.mHour = 1;
          alarm.mMinute = 1;
          alarm.mTag = "Tag";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, alarm);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          // 读取设备上所有的闹钟
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, ID_ALL);
        }
        break;
      case BleKey.UNIT_SET:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 公英制切换, 0: 公制; 1: 英制   en: Unit switch, 0: metric system; 1: British system
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 0);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.NOTIFICATION_REMINDER:
        // 设置是否开启消息推送
        if(Platform.isIOS) {
          BleNotificationSettingsToIOS notification = BleNotificationSettingsToIOS();
          notification.enable(BleNotificationSettingsToIOS.CALL);//open
          notification.enable(BleNotificationSettingsToIOS.SMS);
          notification.enable(BleNotificationSettingsToIOS.EMAIL);
          notification.enable(BleNotificationSettingsToIOS.SKYPE);
          notification.enable(BleNotificationSettingsToIOS.FACEBOOK_MESSENGER);
          notification.enable(BleNotificationSettingsToIOS.WHATS_APP);
          notification.enable(BleNotificationSettingsToIOS.LINE);
          notification.enable(BleNotificationSettingsToIOS.INSTAGRAM);
          notification.enable(BleNotificationSettingsToIOS.KAKAO_TALK);
          notification.enable(BleNotificationSettingsToIOS.GMAIL);
          notification.enable(BleNotificationSettingsToIOS.TWITTER);
          notification.enable(BleNotificationSettingsToIOS.LINKED_IN);
          notification.enable(BleNotificationSettingsToIOS.SINA_WEIBO);
          notification.enable(BleNotificationSettingsToIOS.BAND);
          notification.enable(BleNotificationSettingsToIOS.TELEGRAM);
          notification.enable(BleNotificationSettingsToIOS.BETWEEN);
          notification.enable(BleNotificationSettingsToIOS.NAVERCAFE);
          notification.enable(BleNotificationSettingsToIOS.YOUTUBE);
          notification.enable(BleNotificationSettingsToIOS.NETFLIX);
          // 2022-12-05 新增加的APP推送开关功能  en: 2022-12-05 Added APP push switch function
          notification.enable(BleNotificationSettingsToIOS.Tik_Tok);
          notification.enable(BleNotificationSettingsToIOS.SNAPCHAT);
          notification.enable(BleNotificationSettingsToIOS.AMAZON);
          notification.enable(BleNotificationSettingsToIOS.UBER);
          notification.enable(BleNotificationSettingsToIOS.LYFT);
          notification.enable(BleNotificationSettingsToIOS.GOOGLE_MAPS);
          notification.enable(BleNotificationSettingsToIOS.SLACK);
          notification.enable(BleNotificationSettingsToIOS.DISCORD);

          notification.disable(BleNotificationSettingsToIOS.WE_CHAT);//close
          notification.disable(BleNotificationSettingsToIOS.QQ);
          notification.disable(BleNotificationSettingsToIOS.MIRROR_PHONE);   //  Other APP push switch settings

          String map = "";
          BleNotificationSettingsToIOS.BIT_MASKS.forEach((key, value) {
            bool isOpen = notification.isEnabled(key);
            map = "$map$key:$isOpen ";
          });
          BleLog.d('BleNotificationSettingsToIOS - $map');
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, notification);
        } else {
          initPlatformState();
          startListening();
        }
        break;

      case BleKey.NOTIFICATION_REMINDER2:  // 消息推送协议2
        if (!Platform.isIOS) {
          // 这个指令仅仅iOS 支持
          break;
        }

        if (bleKeyFlag == BleKeyFlag.UPDATE) { // 32769
          BleNotificationSettingsToIOS2 notification2 = BleNotificationSettingsToIOS2();
          notification2.enable(BleNotificationSettingsToIOS2.CALL);//open
          notification2.enable(BleNotificationSettingsToIOS2.SMS);
          notification2.enable(BleNotificationSettingsToIOS2.EMAIL);
          notification2.enable(BleNotificationSettingsToIOS2.SKYPE);
          notification2.enable(BleNotificationSettingsToIOS2.FACEBOOK_MESSENGER);
          notification2.enable(BleNotificationSettingsToIOS2.WHATS_APP);
          notification2.enable(BleNotificationSettingsToIOS2.Dingding_Push);


          String map = "";
          BleNotificationSettingsToIOS2.BIT_MASKS.forEach((key, value) {
            bool isOpen = notification2.isEnabled(key);
            map = "$map$key:$isOpen ";
          });
          BleLog.d('BleNotificationSettingsToIOS2 - $map');
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, notification2);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }

        break;

      case BleKey.ANTI_LOST:
        // 设置防丢提醒
        BleConnector.getInstance.sendBoolean(bleKey, bleKeyFlag, true);
        break;
      case BleKey.HR_MONITORING:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          BleHrMonitoringSettings hrMonitoringSettings = BleHrMonitoringSettings();
          hrMonitoringSettings.mInterval = 120;
          hrMonitoringSettings.mBleTimeRange = BleTimeRange(1, 8, 0, 22, 0);
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, hrMonitoringSettings);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      case BleKey.GIRL_CARE:
        BleGirlCareSettings girlCareSettings = BleGirlCareSettings();
        girlCareSettings.mEnabled = 1;
        girlCareSettings.mReminderHour = 9;
        girlCareSettings.mReminderMinute = 0;
        girlCareSettings.mMenstruationReminderAdvance = 2;
        girlCareSettings.mOvulationReminderAdvance = 2;
        girlCareSettings.mLatestYear = 2020;
        girlCareSettings.mLatestMonth = 1;
        girlCareSettings.mLatestDay = 1;
        girlCareSettings.mMenstruationDuration = 7;
        girlCareSettings.mMenstruationPeriod = 30;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, girlCareSettings);
        break;
      case BleKey.DRINK_WATER:
        if (bleKeyFlag == BleKeyFlag.UPDATE) {
          // 设置喝水提醒
          BleDrinkWaterSettings drinkWaterSettings = BleDrinkWaterSettings();
          drinkWaterSettings.mEnabled = 1;
          // Monday ~ Saturday
          drinkWaterSettings.mRepeat = BleRepeat.MONDAY | BleRepeat.TUESDAY | BleRepeat.WEDNESDAY | BleRepeat.THURSDAY | BleRepeat.FRIDAY | BleRepeat.SATURDAY;
          drinkWaterSettings.mStartHour = 1;
          drinkWaterSettings.mEndHour = 22;
          drinkWaterSettings.mInterval = 60;
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, drinkWaterSettings);
        }
        break;
      case BleKey.IBEACON_SET:
        if (Platform.isAndroid) {
          //安卓不需要ibeancon，强制关闭，省电
          BleConnector.getInstance.sendInt8(BleKey.IBEACON_SET, BleKeyFlag.UPDATE, 0);
        } else {
          //如果ios需要保活就打开ibeancon
          BleConnector.getInstance.sendInt8(BleKey.IBEACON_SET, BleKeyFlag.UPDATE, 1);
        }
        break;
      case BleKey.LOVE_TAP_USER:
        if (bleKeyFlag == BleKeyFlag.CREATE) {
          BleLoveTapUser obj = BleLoveTapUser();
          obj.mId = 1;
          obj.mName = "User 1";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        } else if (bleKeyFlag == BleKeyFlag.DELETE) {
          int id = 1;
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, id);
        } else if (bleKeyFlag == BleKeyFlag.UPDATE) {
          BleLoveTapUser obj = BleLoveTapUser();
          obj.mId = 1;
          obj.mName = "User A";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          // 读取设备上所有的数据
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, ID_ALL);
        }
        break;
      case BleKey.MEDICATION_REMINDER:
        if (bleKeyFlag == BleKeyFlag.CREATE) {
          BleMedicationReminder obj = BleMedicationReminder();
          obj.mType = BleMedicationReminder.TYPE_TABLET;
          obj.mUnit = BleMedicationReminder.UNIT_PIECE;
          obj.mDosage = 1;
          obj.mRepeat = BleRepeat.WORKDAY;
          obj.mRemindTimes = 6;
          obj.mRemindTime1 = BleHmTime(9, 47);
          obj.mRemindTime2 = BleHmTime(9, 48);
          obj.mRemindTime3 = BleHmTime(9, 49);
          obj.mRemindTime4 = BleHmTime(9, 50);
          obj.mRemindTime5 = BleHmTime(9, 51);
          obj.mRemindTime6 = BleHmTime(9, 52);
          obj.mStartYear = 2022;
          obj.mStartMonth = 12;
          obj.mStartDay = 16;
          obj.mEndYear = 2022;
          obj.mEndMonth = 12;
          obj.mEndDay = 19;
          obj.mName = "name 1";
          obj.mLabel = "lable 1";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        } else if (bleKeyFlag == BleKeyFlag.DELETE) {
          int id = 0;
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, id);
        } else if (bleKeyFlag == BleKeyFlag.UPDATE) {
          BleMedicationReminder obj = BleMedicationReminder();
          obj.mId = 0;
          obj.mType = BleMedicationReminder.TYPE_TABLET;
          obj.mUnit = BleMedicationReminder.UNIT_PIECE;
          obj.mRepeat = BleRepeat.WORKDAY;
          obj.mDosage = 1;
          obj.mRemindTimes = 6;
          obj.mRemindTime1 = BleHmTime(16, 1);
          obj.mRemindTime2 = BleHmTime(16, 2);
          obj.mRemindTime3 = BleHmTime(16, 3);
          obj.mRemindTime4 = BleHmTime(16, 4);
          obj.mRemindTime5 = BleHmTime(16, 5);
          obj.mRemindTime6 = BleHmTime(16, 6);
          obj.mStartYear = 2022;
          obj.mStartMonth = 11;
          obj.mStartDay = 30;
          obj.mEndYear = 2022;
          obj.mEndMonth = 12;
          obj.mEndDay = 11;
          obj.mName = "name A";
          obj.mLabel = "lable A";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          // 读取设备上所有的数据
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, ID_ALL);
        }
        break;
      case BleKey.DEVICE_INFO:
        BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        break;
      case BleKey.HR_WARNING_SET:
        BleHrWarningSettings hrWarningSettings = BleHrWarningSettings();
        hrWarningSettings.mHighSwitch = 1;
        hrWarningSettings.mHighValue = 120;
        hrWarningSettings.mLowSwitch = 1;
        hrWarningSettings.mLowValue = 60;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, hrWarningSettings);
        break;
      case BleKey.SLEEP_MONITORING:
        BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        BleSleepMonitoringSettings sleepMonitoringSettings = BleSleepMonitoringSettings();
        sleepMonitoringSettings.mEnabled = 1;
        sleepMonitoringSettings.mStartHour = 12;
        sleepMonitoringSettings.mStartMinute = 1;
        sleepMonitoringSettings.mEndHour = 12;
        sleepMonitoringSettings.mEndMinute = 1;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, sleepMonitoringSettings);
        break;

      //CONNECT
      case BleKey.IDENTITY:
        if (bleKeyFlag == BleKeyFlag.DELETE) {
            // 发送解除绑定指令, 有些设备回复后会触发BleHandleCallback.onIdentityDelete()
            BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
            Future.delayed(const Duration(milliseconds: 2000),(){
              BleConnector.getInstance.unbind();
              _unbindDone();
            });
        } else if (bleKeyFlag == BleKeyFlag.CREATE) {
          // 绑定设备, 外部无需手动调用, 框架内部会自动发送该指令
          BleConnector.getInstance.sendInt32(bleKey, bleKeyFlag, Random().nextInt(100));
        } else if (bleKeyFlag == BleKeyFlag.READ) {
          BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        }
        break;
      //PUSH
      case BleKey.NOTIFICATION:
        // BleNotification notification = BleNotification();
        // notification.mCategory = BleNotification.CATEGORY_INCOMING_CALL;
        // notification.mTime = DateTime.now().millisecondsSinceEpoch;
        // notification.mTitle = "12345678";
        // notification.mContent = "Incoming call";

        // BleNotification notification = BleNotification();
        // notification.mCategory = BleNotification.CATEGORY_INCOMING_CALL;

        BleNotification notification = BleNotification();
        notification.mCategory = BleNotification.CATEGORY_MESSAGE;
        notification.mTime = DateTime.now().millisecondsSinceEpoch;
        notification.mTitle = "123456";
        notification.mContent = "Missed call";

        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, notification);
        break;
      case BleKey.MUSIC_CONTROL:
        //只针对安卓平台，依赖NotificationListenerService，需要开启相关的权限
        if (Platform.isAndroid) {
          BleLog.d("start listening");
          var hasPermission = await NotificationsListener.hasPermission;
          if (!hasPermission!) {
            BleLog.d("no permission, so open settings");
            NotificationsListener.openPermissionSettings();
            return;
          }

          var isR = await NotificationsListener.isRunning;

          //NotificationListenerService在一些手机上不一定能正常运行
          //确保NotificationListenerService运行中
          if (isR!) {
            // bool isRunning = await BleConnector.getInstance.isMusicControllerRunning();
            // BleLog.d("isMusicControllerRunning -> $isRunning");
            BleConnector.getInstance.startMusicController();
          } else {
            BleConnector.getInstance.stopMusicController();//这里只是示例，还要根据app的实际情况来操作
          }
        }
        break;
      case BleKey.SCHEDULE:
        if (bleKeyFlag == BleKeyFlag.CREATE) {
          BleSchedule schedule = BleSchedule();
          schedule.mId = 3;
          schedule.mYear = 2022;
          schedule.mMonth = 12;
          schedule.mDay = 1;
          schedule.mHour = 12;
          schedule.mMinute = 12;
          schedule.mAdvance = 0;
          schedule.mTitle = "Title8";
          schedule.mContent = "Content8";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, schedule);
        } else if (bleKeyFlag == BleKeyFlag.DELETE) {
          BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, 3);
        } else if (bleKeyFlag == BleKeyFlag.UPDATE) {
          BleSchedule schedule = BleSchedule();
          schedule.mId = 3;
          schedule.mYear = 2022;
          schedule.mMonth = 1;
          schedule.mDay = 1;
          schedule.mHour = 12;
          schedule.mMinute = 12;
          schedule.mAdvance = 0;
          schedule.mTitle = "Title9";
          schedule.mContent = "Content9";
          BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, schedule);
        }
        break;
      case BleKey.WEATHER_REALTIME:
        BleWeather weather = BleWeather();
        weather.mCurrentTemperature = 1;
        weather.mMaxTemperature = 1;
        weather.mMinTemperature = 1;
        weather.mWeatherCode = BleWeather.RAINY;
        weather.mWindSpeed = 1;
        weather.mHumidity = 1;
        weather.mVisibility = 1;
        weather.mUltraVioletIntensity = 1;
        weather.mPrecipitation = 1;

        BleWeatherRealtime weatherRealtime = BleWeatherRealtime();
        weatherRealtime.mTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        weatherRealtime.mWeather = weather;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, weatherRealtime);
        break;
      case BleKey.WEATHER_FORECAST:
        BleWeather weather1 = BleWeather();
        weather1.mCurrentTemperature = 1;
        weather1.mMaxTemperature = 1;
        weather1.mMinTemperature = 1;
        weather1.mWeatherCode = BleWeather.OVERCAST;
        weather1.mWindSpeed = 1;
        weather1.mHumidity = 1;
        weather1.mVisibility = 1;
        weather1.mUltraVioletIntensity = 1;
        weather1.mPrecipitation = 1;

        BleWeather weather2 = BleWeather();
        weather2.mCurrentTemperature = 1;
        weather2.mMaxTemperature = 1;
        weather2.mMinTemperature = 1;
        weather2.mWeatherCode = BleWeather.RAINY;
        weather2.mWindSpeed = 1;
        weather2.mHumidity = 1;
        weather2.mVisibility = 1;
        weather2.mUltraVioletIntensity = 1;
        weather2.mPrecipitation = 1;

        BleWeather weather3 = BleWeather();
        weather3.mCurrentTemperature = 1;
        weather3.mMaxTemperature = 1;
        weather3.mMinTemperature = 1;
        weather3.mWeatherCode = BleWeather.CLOUDY;
        weather3.mWindSpeed = 1;
        weather3.mHumidity = 1;
        weather3.mVisibility = 1;
        weather3.mUltraVioletIntensity = 1;
        weather3.mPrecipitation = 1;

        BleWeatherForecast weatherForecast = BleWeatherForecast();
        weatherForecast.mTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        weatherForecast.mWeather1 = weather1;
        weatherForecast.mWeather2 = weather2;
        weatherForecast.mWeather3 = weather3;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, weatherForecast);
        break;
      case BleKey.NEWS_FEED:
        BleNewsFeed obj = BleNewsFeed();
        obj.mCategory = 0;
        obj.mTime = DateTime.now().millisecondsSinceEpoch;
        obj.mUid = 123;
        obj.mTitle = "title 1";
        obj.mContent = "content 1";
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        break;
      case BleKey.WEATHER_REALTIME2:
        BleWeather2 weather = BleWeather2();
        weather.mCurrentTemperature = 1;
        weather.mMaxTemperature = 1;
        weather.mMinTemperature = 1;
        weather.mWeatherCode = BleWeather2.RAINY;
        weather.mWindSpeed = 1;
        weather.mHumidity = 1;
        weather.mVisibility = 1;
        weather.mUltraVioletIntensity = 1;
        weather.mPrecipitation = 1;
        weather.mSunriseHour = 8;
        weather.mSunrisMinute = 1;
        weather.mSunrisSecond = 2;
        weather.mSunsetHour = 18;
        weather.mSunsetMinute = 1;
        weather.mSunsetSecond = 2;

        BleWeatherRealtime2 weatherRealtime = BleWeatherRealtime2();
        weatherRealtime.mTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        weatherRealtime.mCityName = "New York";
        weatherRealtime.mWeather = weather;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, weatherRealtime);
        break;
      case BleKey.WEATHER_FORECAST2:
        BleWeather2 weather1 = BleWeather2();
        weather1.mCurrentTemperature = 1;
        weather1.mMaxTemperature = 1;
        weather1.mMinTemperature = 1;
        weather1.mWeatherCode = BleWeather2.OVERCAST;
        weather1.mWindSpeed = 1;
        weather1.mHumidity = 1;
        weather1.mVisibility = 1;
        weather1.mUltraVioletIntensity = 1;
        weather1.mPrecipitation = 1;
        weather1.mSunriseHour = 8;
        weather1.mSunrisMinute = 1;
        weather1.mSunrisSecond = 2;
        weather1.mSunsetHour = 18;
        weather1.mSunsetMinute = 1;
        weather1.mSunsetSecond = 2;

        BleWeather2 weather2 = BleWeather2();
        weather2.mCurrentTemperature = 1;
        weather2.mMaxTemperature = 1;
        weather2.mMinTemperature = 1;
        weather2.mWeatherCode = BleWeather2.RAINY;
        weather2.mWindSpeed = 1;
        weather2.mHumidity = 1;
        weather2.mVisibility = 1;
        weather2.mUltraVioletIntensity = 1;
        weather2.mPrecipitation = 1;
        weather2.mSunriseHour = 8;
        weather2.mSunrisMinute = 1;
        weather2.mSunrisSecond = 2;
        weather2.mSunsetHour = 18;
        weather2.mSunsetMinute = 1;
        weather2.mSunsetSecond = 2;

        BleWeather2 weather3 = BleWeather2();
        weather3.mCurrentTemperature = 1;
        weather3.mMaxTemperature = 1;
        weather3.mMinTemperature = 1;
        weather3.mWeatherCode = BleWeather2.CLOUDY;
        weather3.mWindSpeed = 1;
        weather3.mHumidity = 1;
        weather3.mVisibility = 1;
        weather3.mUltraVioletIntensity = 1;
        weather3.mPrecipitation = 1;
        weather3.mSunriseHour = 8;
        weather3.mSunrisMinute = 1;
        weather3.mSunrisSecond = 2;
        weather3.mSunsetHour = 18;
        weather3.mSunsetMinute = 1;
        weather3.mSunsetSecond = 2;

        BleWeather2 weather4 = BleWeather2();
        weather4.mCurrentTemperature = 1;
        weather4.mMaxTemperature = 1;
        weather4.mMinTemperature = 1;
        weather4.mWeatherCode = BleWeather2.CLOUDY;
        weather4.mWindSpeed = 1;
        weather4.mHumidity = 1;
        weather4.mVisibility = 1;
        weather4.mUltraVioletIntensity = 1;
        weather4.mPrecipitation = 1;
        weather4.mSunriseHour = 8;
        weather4.mSunrisMinute = 1;
        weather4.mSunrisSecond = 2;
        weather4.mSunsetHour = 18;
        weather4.mSunsetMinute = 1;
        weather4.mSunsetSecond = 2;

        BleWeather2 weather5 = BleWeather2();
        weather5.mCurrentTemperature = 1;
        weather5.mMaxTemperature = 1;
        weather5.mMinTemperature = 1;
        weather5.mWeatherCode = BleWeather2.CLOUDY;
        weather5.mWindSpeed = 1;
        weather5.mHumidity = 1;
        weather5.mVisibility = 1;
        weather5.mUltraVioletIntensity = 1;
        weather5.mPrecipitation = 1;
        weather5.mSunriseHour = 8;
        weather5.mSunrisMinute = 1;
        weather5.mSunrisSecond = 2;
        weather5.mSunsetHour = 18;
        weather5.mSunsetMinute = 1;
        weather5.mSunsetSecond = 2;

        BleWeather2 weather6 = BleWeather2();
        weather6.mCurrentTemperature = 1;
        weather6.mMaxTemperature = 1;
        weather6.mMinTemperature = 1;
        weather6.mWeatherCode = BleWeather2.CLOUDY;
        weather6.mWindSpeed = 1;
        weather3.mHumidity = 1;
        weather6.mVisibility = 1;
        weather6.mUltraVioletIntensity = 1;
        weather6.mPrecipitation = 1;
        weather6.mSunriseHour = 8;
        weather6.mSunrisMinute = 1;
        weather6.mSunrisSecond = 2;
        weather6.mSunsetHour = 18;
        weather6.mSunsetMinute = 1;
        weather6.mSunsetSecond = 2;

        BleWeather2 weather7 = BleWeather2();
        weather7.mCurrentTemperature = 1;
        weather7.mMaxTemperature = 1;
        weather7.mMinTemperature = 1;
        weather7.mWeatherCode = BleWeather2.CLOUDY;
        weather7.mWindSpeed = 1;
        weather7.mHumidity = 1;
        weather7.mVisibility = 1;
        weather7.mUltraVioletIntensity = 1;
        weather7.mPrecipitation = 1;
        weather7.mSunriseHour = 8;
        weather7.mSunrisMinute = 1;
        weather7.mSunrisSecond = 2;
        weather7.mSunsetHour = 18;
        weather7.mSunsetMinute = 1;
        weather7.mSunsetSecond = 2;

        BleWeatherForecast2 weatherForecast = BleWeatherForecast2();
        weatherForecast.mTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        weatherForecast.mCityName = "New York";
        weatherForecast.mWeather1 = weather1;
        weatherForecast.mWeather2 = weather2;
        weatherForecast.mWeather3 = weather3;
        weatherForecast.mWeather4 = weather4;
        weatherForecast.mWeather5 = weather5;
        weatherForecast.mWeather6 = weather6;
        weatherForecast.mWeather7 = weather7;
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, weatherForecast);
        break;

      //DATA
      case BleKey.DATA_ALL:
      case BleKey.ACTIVITY:
      case BleKey.HEART_RATE:
      case BleKey.BLOOD_PRESSURE:
      case BleKey.SLEEP:
      case BleKey.WORKOUT:
      case BleKey.LOCATION:
      case BleKey.TEMPERATURE:
      case BleKey.BLOOD_OXYGEN:
      case BleKey.HRV:
      case BleKey.PRESSURE:
      case BleKey.WORKOUT2:
      case BleKey.BLOOD_GLUCOSE:
        BleConnector.getInstance.sendData(bleKey, bleKeyFlag);
        break;

      //CONTROL
      case BleKey.CAMERA :
        ///[CameraState]
        BleConnector.getInstance.sendInt8(bleKey, bleKeyFlag, CameraState.ENTER);
        break;
      case BleKey.LOVE_TAP:
        BleLoveTap obj = BleLoveTap();
        obj.mTime = DateTime.now().millisecondsSinceEpoch;
        obj.mId = 1;
        obj.mActionType = 1;/// ACTION_DOWN ,ACTION_UP
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, obj);
        break;

      //IO
      case BleKey.WATCH_FACE:
      case BleKey.AGPS_FILE:
      case BleKey.FONT_FILE:
      case BleKey.UI_FILE:
      case BleKey.LANGUAGE_FILE:
      case BleKey.OTA_FILE:
        if (bleKey == BleKey.WATCH_FACE && bleKeyFlag == BleKeyFlag.NONE) {
          Navigator.of(context).popAndPushNamed('/watchface_page');
        } else {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            String? path = result.files.single.path;
            if (path != null) {
              File file = File(path);
              BleConnector.getInstance.sendStream(bleKey, bleKeyFlag, file);
            }
          }
        }
        break;
      case BleKey.CONTACT:
        //默认支持20条记录，直接将记录同步过去即可，会覆盖已有的记录
        BleAddressBook addressBook = BleAddressBook();
        for (var i = 0; i < 6; i++) {
          BleContactPerson person = BleContactPerson();
          person.userName = "userName $i";
          person.userPhone = "1234567890$i";
          addressBook.personList.add(person);
        }
        BleConnector.getInstance.sendObject(bleKey, bleKeyFlag, addressBook);

        //清空使用delete
        // BleConnector.getInstance.sendData(bleKey, BleKeyFlag.DELETE);
        break;
      default:
        showToast("$bleKey => $bleKeyFlag");
        break;
    }
  }

  @override
  void onReadActivity(List<BleActivity> activities) {
    showToast("$activities");

    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(activities[0].mTime);

    // Need to set BleConnector.getInstance.setDataKeyAutoDelete(false)
    // dateKeyRead(activities, BleKey.ACTIVITY);
  }

  @override
  void onReadHeartRate(List<BleHeartRate> heartRates) {
    showToast("$heartRates");

    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(heartRates[0].mTime);
  }

  @override
  void onReadBloodPressure(List<BleBloodPressure> bloodPressures) {
    showToast("$bloodPressures");

    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(bloodPressures[0].mTime);
  }

  @override
  void onReadSleep(List<BleSleep> sleeps) {
    showToast("$sleeps");

    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(sleeps[0].mTime);

    //这里只是示例，[sleeps]数据最好是保存在本地的完整数据
    List<BleSleep> tmp = BleSleep.analyseSleep(sleeps);
    print("getSleepStatusDuration  begin:");
    print(BleSleep.getSleepStatusDuration(tmp));
    print("getSleepStatusDuration  end<<");
  }

  @override
  void onReadWorkout(List<BleWorkout> workouts) {
    showToast("$workouts");

    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(workouts[0].mStart);
    toTimeMillis(workouts[0].mEnd);
  }

  @override
  void onReadTemperature(List<BleTemperature> temperatures) {
    showToast("$temperatures");
    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(temperatures[0].mTime);
  }

  @override
  void onReadBloodOxygen(List<BleBloodOxygen> bloodOxygen) {
    showToast("$bloodOxygen");
    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(bloodOxygen[0].mTime);
  }

  @override
  void onReadBleHrv(List<BleHrv> hrv) {
    showToast("$hrv");
    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(hrv[0].mTime);
  }

  @override
  void onReadPressure(List<BlePressure> pressures) {
    showToast("$pressures");
    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(pressures[0].mTime);
  }

  @override
  void onReadWorkout2(List<BleWorkout2> workouts) {
    showToast("$workouts");
    ///blexxxx.mTime to milliseconds demo
    toTimeMillis(workouts[0].mStart);
  }

  ///设备主动解绑时触发。例如设备恢复出厂设置
  @override
  void onIdentityDeleteByDevice(bool isDevice) async {
    showToast("onIdentityDeleteByDevice $isDevice");
    // 设备未连接, 强制解除绑定
    BleConnector.getInstance.unbind();
    _unbindDone();
  }

  @override
  void onReadPower(int power) {
    showToast("onReadPower $power");
  }

  @override
  void onReadFirmwareVersion(String version) {
    showToast("onReadFirmwareVersion $version");
  }

  @override
  void onReadSedentariness(BleSedentarinessSettings sedentarinessSettings) {
    showToast("onReadSedentariness $sedentarinessSettings");
  }

  @override
  void onReadNoDisturb(BleNoDisturbSettings noDisturbSettings) {
    showToast("onReadNoDisturb $noDisturbSettings");
  }

  @override
  void onNoDisturbUpdate(BleNoDisturbSettings noDisturbSettings) {
    showToast("onNoDisturbUpdate $noDisturbSettings");
  }

  @override
  void onReadAlarm(List<BleAlarm> alarms) {
    showToast("onReadAlarm $alarms");
  }

  @override
  void onAlarmUpdate(BleAlarm alarm) {
    showToast("onAlarmUpdate $alarm");
  }

  @override
  void onAlarmDelete(int id) {
    showToast("onAlarmDelete $id");
  }

  @override
  void onAlarmAdd(BleAlarm alarm) {
    showToast("onAlarmAdd $alarm");
  }

  @override
  void onFindPhone(bool start) {
    showToast("onFindPhone $start");
  }

  @override
  void onReadUiPackVersion(String version) {
    showToast("onReadUiPackVersion $version");
  }

  @override
  void onReadLanguagePackVersion(BleLanguagePackVersion version) {
    showToast("onReadLanguagePackVersion $version");
  }

  @override
  void onStreamProgress(bool status, int errorCode, int total, int completed) {
    BleLog.d("onStreamProgress $status $errorCode progress:${completed / total}");

    if (status) {
      if (total == completed) {
        showToast("onStreamProgress done");
      }
    } else {
      showToast("onStreamProgress errorCode:$errorCode");
    }
  }

  @override
  void onCameraStateChange(int cameraState) {
    showToast("onCameraStateChange $cameraState");
  }

  @override
  void onReadDeviceInfo(BleDeviceInfo deviceInfo) {
    showToast("onReadDeviceInfo $deviceInfo");
  }

  @override
  void onReadTemperatureUnit(int value) {

    // 设置温度单位 0:°C  1:°F  == Set temperature unit 0: Celsius °C 1: Fahrenheit °F
    var infoStr = value == 0 ? "value:0 Celsius °C" : "value:1 Fahrenheit °F";
    showToast("onReadTemperatureUnit \n $infoStr", displayTime: const Duration(milliseconds: 3000));
  }

  @override
  void onReadDateFormat(int value) {
    /**
     * 日期格式设置
     * Date format Setting
     *
     * value 0 = "年/月/日"   "YYYY/MM/dd"
     * value 1 = "日/月/年"   "dd/MM/YYYY""
     * value 2 = "月/日/年"   "MM/dd/YYYY"
     */

    var infoStr = "";
    if (value == 0) {
      infoStr = "YYYY/MM/dd";
    } else if (value == 1) {
      infoStr = "dd/MM/YYYY";
    } else if (value == 2) {
      infoStr = "MM/dd/YYYY";
    }

    showToast("onReadDateFormat \n $infoStr", displayTime: const Duration(milliseconds: 3000));
  }

  @override
  void onPowerSaveModeState(int state) {
    showToast("onPowerSaveModeState $state");
  }

  @override
  void onPowerSaveModeStateChange(int state) {
    showToast("onPowerSaveModeStateChange $state");
  }

  @override
  void onReadLoveTapUser(List<BleLoveTapUser> loveTapUsers) {
    showToast("onReadLoveTapUser $loveTapUsers");
  }

  @override
  void onLoveTapUserUpdate(BleLoveTapUser loveTapUser) {
    showToast("onLoveTapUserUpdate $loveTapUser");
  }

  @override
  void onLoveTapUserDelete(int id) {
    showToast("onLoveTapUserDelete id:$id");
  }

  @override
  void onReadMedicationReminder(List<BleMedicationReminder> medicationReminders) {
    showToast("onReadMedicationReminder $medicationReminders");
  }

  @override
  void onMedicationReminderUpdate(BleMedicationReminder medicationReminder) {
    showToast("onMedicationReminderUpdate $medicationReminder");
  }

  @override
  void onMedicationReminderDelete(int id) {
    showToast("onMedicationReminderDelete id:$id");
  }

  @override
  void onLoveTapUpdate(BleLoveTap loveTap) {
    showToast("onLoveTapUpdate $loveTap");
  }

  @override
  void onReadUnit(int value) {
    showToast("onReadUnit value:$value");
  }

  @override
  void onReadDeviceInfo2(BleDeviceInfo2 deviceInfo) {
    showToast("onReadDeviceInfo2 $deviceInfo");
  }

  @override
  void onReadHrMonitoringSettings(BleHrMonitoringSettings hrMonitoringSettings) {
    showToast("onReadHrMonitoringSettings $hrMonitoringSettings");
  }

  @override
  void onUpdateHeartRate(BleHeartRate heartRate) {
    showToast("onUpdateHeartRate $heartRate");
  }

  @override
  void onReadBacklight(int value) {
    showToast("onReadBacklight $value");
  }

  @override
  void onReadHourSystem(int value) {
    showToast("onReadHourSystem $value");
  }

  void dateKeyRead(List list, BleKey bleKey) {
    int dataCount = list.length;
    if (dataCount > 0) {
      BleConnector.getInstance.sendData(bleKey, BleKeyFlag.DELETE);
    }
    if (dataCount <= 1) {
      showToast("Read done");
    } else {
      BleConnector.getInstance.sendData(bleKey, BleKeyFlag.READ);
    }
  }
}

