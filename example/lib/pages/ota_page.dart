import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class OTAPage extends StatefulWidget {

  final BleDevice? mBleDevice;
  const OTAPage(this.mBleDevice);

  @override
  State<OTAPage> createState() => _OTAPageState();
}

class _OTAPageState extends State<OTAPage> with BleHandleCallback {

  String text = "Progress";

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
      String? path=result.files.single.path;
      if(path !=null){

        File file = File(path);


        // iOS 升级需要需要注意, Realtek是双备份可以不用考虑修复问题, JL杰理平台是单备份, 所以需要考虑到OTA失败, 固件修复的情况
        // iOS 升级需要传递4个参数
        // 1.mainServiceUUID 主服务器UUID, 这个是固定值, 只要使用我们公司的设备无论哪个型号的, 这个参数就可以传递"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
        // 2.platform, 平台, 告诉SDK当前设备使用的是什么平台, 目前支持JL杰理平台和Realtek平台OTA升级
        // 3.isDfu: 是否dfu模式, 固件升级时候传递false, 如果不传递, 默认为false
        // 4.uuid: 设备的UUID, 可以通过下面的示例代码获取

        // 示例代码 Sample code

        String myMainServiceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
        String myUUID = "";
        var isDfu = false;


        if (widget.mBleDevice == null) {
          // 代表普通OTA升级
          // 固件升级, 必须要uuid参数, 否则无法升级
          // Firmware upgrade requires uuid parameter, otherwise it cannot be upgraded.
          String? uuidString = await BleConnector.getInstance.onRetrieveConnectedDeviceUUID();
          if (uuidString == "") {
            BleLog.d('uuidString 为空, 无法执行OTA');
            BleLog.d('uuidString is empty, unable to perform OTA');
            return;
          }
          myUUID = uuidString!;

          BleConnector.getInstance.startOTA(file, mainServiceUUID: myMainServiceUUID, platform: BleDeviceInfo.PLATFORM_JL, isDfu: isDfu, uuid: myUUID);
        } else {

            // 固件升级, 必须要uuid参数, 否则无法升级
            // Firmware upgrade requires uuid parameter, otherwise it cannot be upgraded.
            String? uuidString = await BleConnector.getInstance.onRetrieveConnectedDeviceUUID();
            if (uuidString == "") {
              BleLog.d('uuidString 为空, 无法执行OTA');
              BleLog.d('uuidString is empty, unable to perform OTA');
              return;
            }
            myUUID = uuidString!;

            BleConnector.getInstance.startOTA(file, mainServiceUUID: myMainServiceUUID, platform: BleDeviceInfo.PLATFORM_JL, isDfu: isDfu, uuid: myUUID);
        }


        ///杰里平台安卓OTA说明
        ///1.正常升级
        ///传入ble地址，如A0:60:35:5E:28:18，sdk会进入校验模式，这个时候设备的地址不变，
        ///校验完成后设备重启进入dfu模式，这个时候设备地址ble+1，如A0:60:35:5E:28:19，sdk会回连，进入正式ota流程。
        ///升级过程中不要锁屏，不然ota失败的概率提高。
        ///2.固件修复
        ///ota失败，设备会停留在dfu模式，这个时候isDfu = true
        // BleConnector.getInstance.startOTA(file, address: "A0:60:35:5E:28:18", isDfu: false);
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
        title: const Text("OTA"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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

