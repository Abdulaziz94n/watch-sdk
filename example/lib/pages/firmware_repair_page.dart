import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class FirmwareRepairPage extends StatefulWidget {

  final BleDevice? mBleDevice;

  const FirmwareRepairPage(this.mBleDevice, {super.key});

  @override
  State<FirmwareRepairPage> createState() => _FirmwareRepairPageState();
}

class _FirmwareRepairPageState extends State<FirmwareRepairPage> with BleHandleCallback {

  String text = "Progress";

  String deviceInfo = "";

  @override
  void onOTAProgress(double progress, int otaStatus, String error) {
    setState(() {
      switch(otaStatus){
        case OTAStatus.OTA_PREPARE:
          text = "OTA_PREPARE";
          break;
        case OTAStatus.OTA_PREPARE_FAILED:
          text = "OTA_PREPARE_FAILED:$error";
          break;
        case OTAStatus.OTA_START:
          text = "OTA_START";
          break;
        case OTAStatus.OTA_CHECKING:
          text = "CHECKING:$progress";
          break;
        case OTAStatus.OTA_UPGRADEING:
          text = "UPGRADEING:$progress";
          break;
        case OTAStatus.OTA_DONE:
          text = "OTA_DONE";
          break;
        case OTAStatus.OTA_FAILED:
          text = "OTA_FAILED:$error";
          break;
      }
    });
  }

  Future<void> _startOTA() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        File file = File(path);
        if (widget.mBleDevice != null) {
          if (Platform.isAndroid) {
            BleConnector.getInstance.startOTA(file, address: widget.mBleDevice!.mAddress);
          } else {

            /**
             * iOS necessary parameters
             * mainServiceUUID: UUID of the main server, which is a fixed value
             * platform: platform, a device used to determine which chip platform
             * isDfu: Whether it is in the situation of OTA failure
             * address: mac address of the device
             */
            String myMainServiceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
            var mAddress = widget.mBleDevice!.mAddress;
            BleConnector.getInstance.startOTA(file, mainServiceUUID: myMainServiceUUID, platform: BleDeviceInfo.PLATFORM_JL, isDfu: true, address: mAddress);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BleConnector.getInstance.addHandleCallback(this);

    // 会调用第三方的ota，需要断开连接，避免受到干扰
    // 这里需要注意, 仅安卓这里执行, iOS不需要这里就断开连接, 将由iOS内部原生代码去断开连接, 注意区分
    if (Platform.isAndroid) {
      BleConnector.getInstance.closeConnection(true);
    }
    setState(() {
      deviceInfo = "name: ${widget.mBleDevice?.mName}\naddress: ${widget.mBleDevice?.mAddress}";
    });
  }

  @override
  void dispose() {
    BleConnector.getInstance.removeHandleCallback(this);
    BleConnector.getInstance.releaseOTA();//退出时释放一下资源
    BleConnector.getInstance.launch();//重新连接
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firmware Repair"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              deviceInfo
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startOTA,
        tooltip: 'start',
        child: const Text('start'),
      ),
    );
  }
}

