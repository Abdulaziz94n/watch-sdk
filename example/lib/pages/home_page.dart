import 'dart:io';
import 'package:sma_coding_dev_flutter_sdk_example/main.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _IndexPageState();
}

class _IndexPageState extends State<HomePage>
    with BleScanCallback, BleHandleCallback {
  List<BleDevice> mList = [];

  late BleScanner mBleScanner;

  String btnText = "Scan";

  @override
  void onBluetoothDisabled() {
    showToast("Please enable bluetooth");
  }

  @override
  void onDeviceFound(BleDevice device) {
    if (device.mRssi > -88) {
      setState(() {
        if (!mList.contains(device)) {
          mList.add(device);
        }
        mList.sort((a, b) => -(a.mRssi).compareTo(b.mRssi));
      });
    }
  }

  @override
  void onScan(bool scan) {
    BleLog.d("onScan($scan)");
    setState(() {
      if (scan) {
        mList.clear();
        btnText = "...";
      } else {
        btnText = "Scan";
      }
    });
  }

  @override
  void onDeviceConnected(BleDevice device) {}

  @override
  void onIdentityCreate(bool status, BleDeviceInfo? deviceInfo) {
    if (status) {//paired successfully
      bool isClassicBluetooth = deviceInfo!.mClassicAddress!.isNotEmpty;
      if(Platform.isAndroid && isClassicBluetooth) {
        BleConnector.getInstance.connectClassic();
      }
      Navigator.of(context).popAndPushNamed('/bleCommand');
    }else {//Pairing failed
      if (Platform.isIOS) {
        // 如果是iOS, 这里代表用户在手表弹出的绑定框上点击'x'
        showToast(
            "iOS The user clicks' x 'on the binding box popped up by the watch",
            displayTime: const Duration(milliseconds: 3000));
      } else {
        BleConnector.getInstance.closeConnection(true);
      }
    }
  }




  /*
  * steps: 步数
  * height: 用户的身高, 请传递公制cm
  * weight: 用户的体重, 请传递公制kg
  * isMan: 是否为女性? 男性:false, 女性:true
  * isMan: 是否为英制? 公制:false, 英制:true
  *
  * steps: number of steps
  * height: User's height, please pass in metric cm
  * weight: User's weight, please pass metric kg
  * isMan: Is it female? male: false, female: true
  * isMan: Is it imperial? Metric: false, Imperial: true
  *
  * goalSetting(10000, 175.0, 65.3, false, false);
  * {distanceValue: 8.4, caloriesValue: 300.37999999999994}
  *
  * goalSetting(10000, 175.0, 65.3, true, false);
  * {distanceValue: 8.4, caloriesValue: 359.15}
  *
  */
  Map<String, double> goalSetting(int steps, double height, double weight, bool isWoman, bool isImperial) {

    var distanceValue = 0.0;
    var caloriesValue = 0.0;

    var distance = 0.48 * steps.toDouble() * height;

    if (isWoman) {

      var calories = 55 * weight * steps.toDouble();

      if (isImperial) {
        distance = distance * 0.6214;
      }

      distanceValue = distance/100000.0;
      caloriesValue = calories/100000.0;
    }else{

      var calories = 46 * weight * steps.toDouble();

      if (isImperial) {
        distance = distance * 0.6214;
      }

      distanceValue = distance/100000.0;
      caloriesValue = calories/100000.0;
    }

    return {"distanceValue": distanceValue, "caloriesValue": caloriesValue};
  }



  @override
  void initState() {
    super.initState();
    BleConnector.getInstance.addHandleCallback(this);
    mBleScanner = BleScanner(const Duration(seconds: 10), this);
  }

  @override
  void dispose() {
    BleConnector.getInstance.removeHandleCallback(this);
    mBleScanner.exit();
    super.dispose();
  }

  void _scan() async {
    if (mBleScanner.isScanning) {
      showToast("scanning");
    } else {
      requestPermission();
    }
  }

  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothConnect, //android
      Permission.bluetoothAdvertise, //android
      Permission.bluetoothScan, //android
      Permission.phone, //android
      Permission.contacts
    ].request();



    // 如果是iOS平台, 需要调用一下这个方法, 返回已经配对的设备列表
    // If it is an iOS platform, you need to call this method to return the list of paired devices
    if (Platform.isIOS) {

      // 获取当前系统已经配对的设备列表 Get the list of devices paired with the current system
      var connectDeviceList = await mBleScanner.onRetrieveConnectedPeripherals();

      // 添加到当前已经搜索到的设备列表里面, 展示给用户 Add it to the currently searched device list and show it to the user
      for (var mDevice in connectDeviceList) {
        mList.add(mDevice);
      }
    }


    mBleScanner.scan(!mBleScanner.isScanning);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: mList.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                  "name: ${mList[i].mName}\naddress: ${mList[i].mAddress}\nrssi: ${mList[i].mRssi}\n"),
              onTap: () {

                // 必要的操作,停止扫描, en:Necessary operation, stop scanning
                mBleScanner.scan(false);


                // 判断当前设备是否处于OTA模式下
                var isDfu = mList[i].isDfu;
                if (isDfu) {
                  // 如果当前处于OTA模式下, 代表设备无法正常工作, 就跳转OTA页面, 修复固件
                  // 故障设备, 需要执行修复操作 en: Faulty equipment, requiring repair operations
                  Navigator.of(context).popAndPushNamed('/ota_page', arguments: mList[i]);
                } else {
                  // 如果不是处于OTA模型, 代表设备正常工作, 正常发起连接即可
                  // 设置需要连接的Mac地址, 注意, 由于iOS的有点不一样, 在连接设备时候调用一次即可, 其他时间不要调用这个方法
                  // 例如重启App时候需要重新连接设备, 这个操作在调用 BleConnector.getInstance.init(); 方法时候, 我们的SDK内部会处理
                  // en:Set the Mac address that you want to connect to. Note that since iOS is a little different, you can only call this method once when you connect to the device. Do not call this method at other times
                  // en: When restart the App needs to be connected devices, for example, the operation in the calling BleConnector.getInstance.init(); Method is handled internally by our SDK
                  BleConnector.getInstance.setAddress(mList[i].mAddress);
                  // Execution connection
                  BleConnector.getInstance.connect(true);
                }
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        tooltip: btnText,
        child: Text(btnText),
      ),
    );
  }
}

Future<void> testDiffActivity() async {
  var detail = await getActivityDiffDetail();//today
  // var detail = await getActivityDiffDetail(date: DateTime.parse("2023-07-30").millisecondsSinceEpoch);
  detail.forEach((element) {
    BleLog.d("detail => $element");
  });
}

Future<void> testActivityTotal() async {
  // var detail = await getActivityTotal();//today, Yesterday, Day Before Yesterday
  var detail = await getActivityTotal(date: DateTime.parse("2023-07-13").millisecondsSinceEpoch);//today, Yesterday, Day Before Yesterday
  // var detail = await getActivityTotal(date: DateTime.parse("2023-07-13").millisecondsSinceEpoch, days: 10, type: 1);
  detail.forEach((element) {
    BleLog.d("detail => $element");
  });
}
