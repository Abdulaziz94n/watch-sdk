import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/ble_command_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/ble_key_flag_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/ble_key_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/firmware_repair_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/firmware_repair_scan_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/home_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/index_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/music_control_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/ota_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/other_page.dart';
import 'package:sma_coding_dev_flutter_sdk_example/pages/watchface_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUiOverlayStyle uiStyle = SystemUiOverlayStyle.light;
  SystemChrome.setSystemUIOverlayStyle(uiStyle);
  
  // 在启动SDK之前, 可以根据自己的需要, 是否开启LoveTap推送测试, 这个功能默认是关闭的
  // Before starting the SDK, you can enable the LoveTap push test according to your own needs. This function is disabled by default
  //BleConnector.getInstance.isOpenLoveTapPush(true);
  // 无论如何, 都应该在启动时候调用初始化我们SDK的方法, en: Anyway, the method that initialized our SDK should be called at startup, right
  initSdk();
  runApp(CodingDemo());
}

class BleConnectorCallback extends BleHandleCallback {

  int mPhoneState = -1;

  @override
  void onSessionStateChange(bool status) {
    ///连接状态发生变化时，重发相应指令
    if (status) {
      BleConnector.getInstance.sendData(BleKey.TIME_ZONE, BleKeyFlag.UPDATE);
      BleConnector.getInstance.sendData(BleKey.TIME, BleKeyFlag.UPDATE);
      // 切换, 0: 24-hourly; 1: 12-hourly
      BleConnector.getInstance.sendInt8(BleKey.HOUR_SYSTEM, BleKeyFlag.UPDATE, 1);
      BleConnector.getInstance.sendData(BleKey.POWER, BleKeyFlag.READ);
      BleConnector.getInstance.sendData(BleKey.FIRMWARE_VERSION, BleKeyFlag.READ);
      BleConnector.getInstance.sendInt8(BleKey.LANGUAGE, BleKeyFlag.UPDATE, Languages.DEFAULT_CODE);
      BleConnector.getInstance.sendData(BleKey.MUSIC_CONTROL, BleKeyFlag.READ);

      ///可以通过[BleDeviceInfo.mSupportIBeaconSet]来确定设备是否支持iBeancon
      ///ios保活可能需要到iBeancon，但是开启这个功能设备会增加耗电量
      // if(deviceInfo.mSupportIBeaconSet == 1) {
      //   if (Platform.isAndroid) {
      //     //安卓不需要iBeancon，强制关闭，省电
      //     BleConnector.getInstance.sendInt8(BleKey.IBEACON_SET, BleKeyFlag.UPDATE, 0);
      //   } else {
      //     BleLog.d("执行开启iBeancon");
      //     //ios需要保活就打开iBeancon
      //     BleConnector.getInstance.sendInt8(BleKey.IBEACON_SET, BleKeyFlag.UPDATE, 1);
      //   }
      // }
    }
  }
}

void initSdk() async {

  //建议保存sdk log，有问题方便分析原因。
  //安卓的sdk log文件保存到/storage/emulated/0/Android/data/package/files/ble_logs目录。
  BleConnector.getInstance.saveLogs(true);
  BleConnector.getInstance.init();
  BleConnector.getInstance.addHandleCallback(BleConnectorCallback());
  if (Platform.isAndroid) {
    //android 12以后要先判断权限，不然会闪退
    //来电时有可能是手机号码，这个时候如果想显示联系人名称则需要Permission.contacts
    if (await Permission.phone.isGranted) {
      BleConnector.getInstance.setPhoneStateListener(true);
    }
  }
  // BleConnector.getInstance.setDataKeyAutoDelete(false);
  BleLog.d("initSdk ok");
}

class CodingDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: (context, child) {
          return MaterialApp(
            builder: (context, child) => FlutterSmartDialog(child: child),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: onGenerateRoute,
            home: const IndexPage(),
          );
        },
      ),
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  var routes = <String, WidgetBuilder>{
    '/home': (context) => const HomePage(title: 'Scan'),
    '/bleCommand': (context) => const BleCommandPage(),
    '/bleKey': (context) => BleKeyPage(settings.arguments as BleCommand),
    '/bleKeyFlag': (context) => BleKeyFlagPage(settings.arguments as BleKey),
    //'/ota_page': (context) => OTAPage(),
    '/watchface_page': (context) => const WatchFacePage(),
    '/other_page': (context) => const OtherPage(),
    '/firmware_repair_scan_page': (context) => const FirmwareRepairScanPage(),
    '/firmware_repair_page': (context) => FirmwareRepairPage(settings.arguments as BleDevice),
    '/music_control_page': (context) => const MusicControlPage(),
  };

  WidgetBuilder? builder;
  if (settings.name == '/ota_page') {
    BleLog.d("请求参数:$settings");
    if (settings.arguments == null) {
      builder = (context) => const OTAPage(null);
    } else {
      builder = (context) => OTAPage(settings.arguments as BleDevice);
    }
  } else {
    builder = routes[settings.name] as WidgetBuilder;
  }

  return MaterialPageRoute(builder: (ctx) => builder!(ctx));
}

void showToast(String msg, {Duration? displayTime}) {
  SmartDialog.showToast(msg,
      displayTime: displayTime ?? const Duration(milliseconds: 500));
}