import 'dart:io';
import 'package:sma_coding_dev_flutter_sdk_example/main.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

class FirmwareRepairScanPage extends StatefulWidget {
  const FirmwareRepairScanPage({Key? key}) : super(key: key);

  @override
  State<FirmwareRepairScanPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<FirmwareRepairScanPage>
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
  void initState() {
    super.initState();
    //需要断开连接，避免受到干扰
    if (Platform.isAndroid) {
      BleConnector.getInstance.closeConnection(true);
    }
    mBleScanner = BleScanner(const Duration(seconds: 10), this);
  }

  @override
  void dispose() {
    mBleScanner.exit();
    BleConnector.getInstance.launch();//重新连接
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

    mBleScanner.scan(!mBleScanner.isScanning);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firmware Repair"),
      ),
      body: ListView.builder(
          itemCount: mList.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                  "name: ${mList[i].mName}\naddress: ${mList[i].mAddress}\nrssi: ${mList[i].mRssi}\nisDfu: ${mList[i].isDfu}\n"),
              onTap: () {
                // 必要的操作,停止扫描, en:Necessary operation, stop scanning
                mBleScanner.scan(false);
                Navigator.of(context).popAndPushNamed('/firmware_repair_page', arguments: mList[i]);
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
