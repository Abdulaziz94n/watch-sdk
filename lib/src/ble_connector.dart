import 'dart:io';

import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';
import 'package:sma_coding_dev_flutter_sdk/src/sdk_method.dart';
import 'package:flutter/services.dart';

import 'common.dart';

class BleConnector {
  static const _channelPrefix = 'com.sma.ble';
  static const MethodChannel _channel =
      MethodChannel('$_channelPrefix/ble_connector', JSONMethodCodec());
  static BleConnector? _instance;

  static BleConnector get getInstance =>
      _instance = _instance ?? BleConnector._internal();
  final List<BleHandleCallback> _bleHandleCallbacks = [];

  //是否缓存activity, 默认缓存
  static bool isCacheActivity = true;

  BleConnector._internal() {
    _addNativeMethodCallHandler();
  }

  Future<void> init() async {
    BleLog.d('BleConnector init()');
    await _channel.invokeMethod(SdkMethod.init);
  }

  Future<void> sendData(BleKey bleKey, BleKeyFlag bleKeyFlag) async {
    Map req = getReq(bleKey, bleKeyFlag, null);
    BleLog.d('sendData $req');
    await _channel.invokeMethod(SdkMethod.sendData, req);
  }

  Future<void> sendInt8(BleKey bleKey, BleKeyFlag bleKeyFlag, int value) async {
    Map req = getReq(bleKey, bleKeyFlag, value);
    BleLog.d('sendInt8 $req');
    await _channel.invokeMethod(SdkMethod.sendInt8, req);
  }

  Future<void> sendInt16(
      BleKey bleKey, BleKeyFlag bleKeyFlag, int value) async {
    Map req = getReq(bleKey, bleKeyFlag, value);
    BleLog.d('sendInt16 $req');
    await _channel.invokeMethod(SdkMethod.sendInt16, req);
  }

  Future<void> sendInt32(
      BleKey bleKey, BleKeyFlag bleKeyFlag, int value) async {
    Map req = getReq(bleKey, bleKeyFlag, value);
    BleLog.d('sendInt32 $req');
    await _channel.invokeMethod(SdkMethod.sendInt32, req);
  }

  Future<void> sendBoolean(
      BleKey bleKey, BleKeyFlag bleKeyFlag, bool value) async {
    Map req = getReq(bleKey, bleKeyFlag, value);
    BleLog.d('sendBoolean $req');
    await _channel.invokeMethod(SdkMethod.sendBoolean, req);
  }

  Future<void> sendObject(
      BleKey bleKey, BleKeyFlag bleKeyFlag, BleBase value) async {
    Map req = getReq(bleKey, bleKeyFlag, value);
    BleLog.d('sendObject $req');
    await _channel.invokeMethod(SdkMethod.sendObject, req);
  }

  // 获取设备的uuid字符串; Get the uuid string of the device
  Future<String?> onRetrieveConnectedDeviceUUID() async {
    BleLog.d('exec onRetrieveConnectedDeviceUUID()');

    var map = await _channel.invokeMethod(SdkMethod.onRetrieveConnectedDeviceUUID);
    String? uuidString = map["uuidString"];
    BleLog.d('onRetrieveConnectedDeviceUUID uuidString: $uuidString');
    return uuidString;
  }


  Future<void> sendStream(
      BleKey bleKey, BleKeyFlag bleKeyFlag, File value) async {
    Map req = getReq(bleKey, bleKeyFlag, value.path);
    BleLog.d('sendStream $req');
    await _channel.invokeMethod(SdkMethod.sendStream, req);
  }

  /// only android
  Future<void> connectClassic() async {
    BleLog.d('connectClassic()');
    await _channel.invokeMethod(SdkMethod.connectClassic);
  }

  Future<void> launch() async {
    BleLog.d('launch()');
    await _channel.invokeMethod(SdkMethod.launch);
  }

  /// unpair
  Future<void> unbind() async {
    BleLog.d('unbind()');
    await _channel.invokeMethod(SdkMethod.unbind);
  }

  /// Is it paired
  Future<bool> isBound() async {
    BleLog.d('isBound()');
    Map result = await _channel.invokeMethod(SdkMethod.isBound);
    return result[SdkMethod.isBound];
  }

  /// The current connection status is available
  Future<bool> isAvailable() async {
    BleLog.d('isAvailable()');
    Map result = await _channel.invokeMethod(SdkMethod.isAvailable);
    return result[SdkMethod.isAvailable];
  }

  /// is it connecting
  Future<bool> isConnecting() async {
    BleLog.d('isConnecting()');
    Map result = await _channel.invokeMethod(SdkMethod.isConnecting);
    return result[SdkMethod.isConnecting];
  }

  /// Only android
  Future<bool> isMusicControllerRunning() async {
    BleLog.d('isMusicControllerRunning()');
    Map result = await _channel.invokeMethod(SdkMethod.isMusicControllerRunning);
    return result[SdkMethod.isMusicControllerRunning];
  }

  /// [address] Android is mac address. iOS supports UUID or mac addresses
  /// Note Because iOS systems are different, you need to distinguish between mac address connections and UUID connections
  /// 1. If it is a UUID connection, just pass in the UUID string
  /// 2.If the connection is a mac address, the mac string is also passed in,
  ///   but please make sure that the device you want to connect to is not in the iOS Settings -> Bluetooth "My Device" list, if it is,
  ///   please remove it (ignore this device), otherwise the connection cannot be made
  Future<void> setAddress(String address) async {
    BleLog.d('setAddress($address)');
    Map req = {'address': address};
    await _channel.invokeMethod(SdkMethod.setAddress, req);
  }

  Future<void> connect(bool connect) async {
    BleLog.d('connect($connect)');
    Map req = {'connect': connect};
    await _channel.invokeMethod(SdkMethod.connect, req);
  }

  /// [stopReconnecting] Whether to reconnect
  Future<void> closeConnection(bool stopReconnecting) async {
    BleLog.d('closeConnection($stopReconnecting)');
    Map req = {'stopReconnecting': stopReconnecting};
    await _channel.invokeMethod(SdkMethod.closeConnection, req);
  }

  /// Due to the different mechanisms for connecting Bluetooth devices between Android and iOS platforms, it is necessary to distinguish
  /// Android platform -> necessary parameters file: OTA file path; just pass the mac address parameter
  /// iOS 升级需要需要注意, Realtek是双备份可以不用考虑修复问题, JL杰理平台是单备份, 所以需要考虑到OTA失败, 固件修复的情况
  /// iOS 升级需要传递4个参数
  /// 1.mainServiceUUID 主服务器UUID, 这个是固定值, 只要使用我们公司的设备无论哪个型号的, 这个参数就可以传递"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
  /// 2.platform, 平台, 告诉SDK当前设备使用的是什么平台, 目前支持JL杰理平台和Realtek平台OTA升级
  /// 3.isDfu: 是否dfu模式, 固件升级时候传递false, 如果不传递, 默认为false
  /// 4.uuid: 设备的UUID, 可以通过下面的示例代码获取
  /// ota失败，设备会停留在dfu模式，这个时候isDfu = true
  /// iOS 固件修复需要传递4个参数
  /// 1.mainServiceUUID 主服务器UUID, 这个是固定值, 只要使用我们公司的设备无论哪个型号的, 这个参数就可以传递"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
  /// 2.platform, 平台, 告诉SDK当前设备使用的是什么平台, 可以通过BleDeviceInfo类中的 mPlatform 获取. 目前支持JL杰理平台和Realtek平台OTA升级
  /// 3.isDfu: 是否dfu模式, OTA失败, 固件修复时候传递true
  /// 3.address: 设备的address, 可以通过BleDeviceInfo类中的 mBleAddress 获取
  /// 从上面可以看出, mainServiceUUID, platform是必要的参数,
  /// 固件升级, 必须传递isDfu==false, 以及uuid参数
  /// 固件修复, 必须传递isDfu==true, 以及address参数
  Future<void> startOTA(File file, {String address = '', String mainServiceUUID = '', String uuid = '', String platform = '', bool isDfu = false}) async {
    BleLog.d(
        'startOTA(path:${file.path}, address:$address, uuid:$uuid, platform:$platform, isDfu:$isDfu)');

    Map req = {
      'filePath': file.path,
      'address': address,
      'mainServiceUUID': mainServiceUUID,
      'uuid': uuid,
      'platform': platform,
      'isDfu': isDfu
    };
    await _channel.invokeMethod(SdkMethod.startOTA, req);
  }

  Future<void> releaseOTA() async {
    BleLog.d('releaseOTA()');
    await _channel.invokeMethod(SdkMethod.releaseOTA);
  }

  /// only android
  Future<void> startMusicController() async {
    BleLog.d('startMusicController()');
    await _channel.invokeMethod(SdkMethod.startMusicController);
  }

  /// only android
  Future<void> stopMusicController() async {
    BleLog.d('stopMusicController()');
    await _channel.invokeMethod(SdkMethod.stopMusicController);
  }

  Future<void> sendMusicPlayState(int state) async {
    BleLog.d('sendMusicPlayState($state)');
    Map req = {'state': state};
    await _channel.invokeMethod(SdkMethod.sendMusicPlayState, req);
  }

  Future<void> sendMusicTitle(String title) async {
    BleLog.d('sendMusicTitle($title)');
    Map req = {'title': title};
    await _channel.invokeMethod(SdkMethod.sendMusicTitle, req);
  }

  /// The current volume of the phone is 0-100
  Future<void> sendPhoneVolume(int volume) async {
    BleLog.d('sendPhoneVolume($volume)');
    Map req = {'volume': volume};
    await _channel.invokeMethod(SdkMethod.sendPhoneVolume, req);
  }

  /// Whether to save the log
  Future<void> saveLogs(bool isSave) async {
    BleLog.d('saveLogs($isSave)');
    Map req = {'isSave': isSave};
    await _channel.invokeMethod(SdkMethod.saveLogs, req);
  }

  /// This method is only supported on the iOS platform
  /// Arrows for turning iBeacon on and off
  /// true to enable monitoring
  /// false stop listening
  Future<void> iBeaconListening(bool isOpen) async {
    BleLog.d('exec iBeaconListening, isOpen:($isOpen)');
    Map req = {'value': isOpen};
    await _channel.invokeMethod(SdkMethod.iBeaconListening, req);
  }

  Future<void> isOpenLoveTapPush(bool isOpen) async {
    BleLog.d('exec isOpenLoveTapPush, isOpen:($isOpen)');
    Map req = {'value': isOpen};
    await _channel.invokeMethod(SdkMethod.isOpenLoveTapPush, req);
  }

  Future<void> killApp() async {
    BleLog.d('exec killApp func');
    await _channel.invokeMethod(SdkMethod.killApp);
  }

  /// only android
  Future<void> setPhoneStateListener(bool enable) async {
    BleLog.d('setPhoneStateListener($enable)');
    Map req = {'enable': enable};
    await _channel.invokeMethod(SdkMethod.setPhoneStateListener, req);
  }

  /// [BleCommand.DATA] The delete command is automatically sent by default after the command read operation.
  /// If automatic deletion is disabled, you need to manually send a delete command after reading the data,
  /// otherwise if there is too much data, only the previous data will be returned
  Future<void> setDataKeyAutoDelete(bool isAutoDelete) async {
    BleLog.d('setDataKeyAutoDelete($isAutoDelete)');
    Map req = {'isAutoDelete': isAutoDelete};
    await _channel.invokeMethod(SdkMethod.setDataKeyAutoDelete, req);
  }

  void addHandleCallback(BleHandleCallback bleHandleCallback) {
    BleLog.d('addHandleCallback');
    if (!_bleHandleCallbacks.contains(bleHandleCallback)) {
      _bleHandleCallbacks.add(bleHandleCallback);
    }
  }

  void removeHandleCallback(BleHandleCallback bleHandleCallback) {
    BleLog.d('removeHandleCallback');
    if (_bleHandleCallbacks.contains(bleHandleCallback)) {
      _bleHandleCallbacks.remove(bleHandleCallback);
    }
  }

  void _addNativeMethodCallHandler() {
    _channel.setMethodCallHandler((MethodCall call) async {
      Map argMap = call.arguments;
      if (call.method == SdkMethod.onDeviceConnected) {
        return _onDeviceConnected(argMap);
      } else if (call.method == SdkMethod.onIdentityCreate) {
        return _onIdentityCreate(argMap);
      } else if (call.method == SdkMethod.onIdentityDelete) {
        return _onIdentityDelete(argMap);
      } else if (call.method == SdkMethod.onIdentityDeleteByDevice) {
        return _onIdentityDeleteByDevice(argMap);
      } else if (call.method == SdkMethod.onSessionStateChange) {
        return _onSessionStateChange(argMap);
      } else if (call.method == SdkMethod.onCommandReply) {
        return _onCommandReply(argMap);
      } else if (call.method == SdkMethod.onReadPower) {
        return _onReadPower(argMap);
      } else if (call.method == SdkMethod.onReadFirmwareVersion) {
        return _onReadFirmwareVersion(argMap);
      } else if (call.method == SdkMethod.onReadSedentariness) {
        return _onReadSedentariness(argMap);
      } else if (call.method == SdkMethod.onReadNoDisturb) {
        return _onReadNoDisturb(argMap);
      } else if (call.method == SdkMethod.onNoDisturbUpdate) {
        return _onNoDisturbUpdate(argMap);
      } else if (call.method == SdkMethod.onReadAlarm) {
        return _onReadAlarm(argMap);
      } else if (call.method == SdkMethod.onAlarmUpdate) {
        return _onAlarmUpdate(argMap);
      } else if (call.method == SdkMethod.onAlarmDelete) {
        return _onAlarmDelete(argMap);
      } else if (call.method == SdkMethod.onAlarmAdd) {
        return _onAlarmAdd(argMap);
      } else if (call.method == SdkMethod.onFindPhone) {
        return _onFindPhone(argMap);
      } else if (call.method == SdkMethod.onReadUiPackVersion) {
        return _onReadUiPackVersion(argMap);
      } else if (call.method == SdkMethod.onReadLanguagePackVersion) {
        return _onReadLanguagePackVersion(argMap);
      } else if (call.method == SdkMethod.onSyncData) {
        return _onSyncData(argMap);
      } else if (call.method == SdkMethod.onReadActivity) {
        return _onReadActivity(argMap);
      } else if (call.method == SdkMethod.onReadHeartRate) {
        return _onReadHeartRate(argMap);
      } else if (call.method == SdkMethod.onUpdateHeartRate) {
        return _onUpdateHeartRate(argMap);
      } else if (call.method == SdkMethod.onReadBloodPressure) {
        return _onReadBloodPressure(argMap);
      } else if (call.method == SdkMethod.onReadSleep) {
        return _onReadSleep(argMap);
      } else if (call.method == SdkMethod.onReadWorkout) {
        return _onReadWorkout(argMap);
      } else if (call.method == SdkMethod.onReadLocation) {
        return _onReadLocation(argMap);
      } else if (call.method == SdkMethod.onDeviceRequestAGpsFile) {
        return _onDeviceRequestAGpsFile(argMap);
      } else if (call.method == SdkMethod.onReadTemperature) {
        return _onReadTemperature(argMap);
      } else if (call.method == SdkMethod.onReadBloodOxygen) {
        return _onReadBloodOxygen(argMap);
      } else if (call.method == SdkMethod.onReadBleHrv) {
        return _onReadBleHrv(argMap);
      } else if (call.method == SdkMethod.onCameraStateChange) {
        return _onCameraStateChange(argMap);
      } else if (call.method == SdkMethod.onCameraResponse) {
        return _onCameraResponse(argMap);
      } else if (call.method == SdkMethod.onStreamProgress) {
        return _onStreamProgress(argMap);
      } else if (call.method == SdkMethod.onRequestLocation) {
        return _onRequestLocation(argMap);
      } else if (call.method == SdkMethod.onReadPressure) {
        return _onReadPressure(argMap);
      } else if (call.method == SdkMethod.onFollowSystemLanguage) {
        return _onFollowSystemLanguage(argMap);
      } else if (call.method == SdkMethod.onReadWeatherRealTime) {
        return _onReadWeatherRealTime(argMap);
      } else if (call.method == SdkMethod.onReadWorkout2) {
        return _onReadWorkout2(argMap);
      } else if (call.method == SdkMethod.onCommandSendTimeout) {
        return _onCommandSendTimeout(argMap);
      } else if (call.method == SdkMethod.onOTAProgress) {
        return _onOTAProgress(argMap);
      } else if (call.method == SdkMethod.onReadNotificationSettings2) {
        return _onReadNotificationSettings2(argMap);
      } else if (call.method == SdkMethod.onReadDeviceInfo) {
        return _onReadDeviceInfo(argMap);
      } else if (call.method == SdkMethod.onReadBleAddress) {
        return _onReadBleAddress(argMap);
      } else if (call.method == SdkMethod.onReceiveMusicCommand) {
        return _onReceiveMusicCommand(argMap);
      } else if (call.method == SdkMethod.onReadTemperatureUnit) {
        return _onReadTemperatureUnit(argMap);
      } else if (call.method == SdkMethod.onReadDateFormat) {
        return _onReadDateFormat(argMap);
      } else if (call.method == SdkMethod.onVibrationUpdate) {
        return _onVibrationUpdate(argMap);
      } else if (call.method == SdkMethod.onBacklightUpdate) {
        return _onBacklightUpdate(argMap);
      } else if (call.method == SdkMethod.onReadGestureWake) {
        return _onReadGestureWake(argMap);
      } else if (call.method == SdkMethod.onGestureWakeUpdate) {
        return _onGestureWakeUpdate(argMap);
      } else if (call.method == SdkMethod.onPowerSaveModeState) {
        return _onPowerSaveModeState(argMap);
      } else if (call.method == SdkMethod.onPowerSaveModeStateChange) {
        return _onPowerSaveModeStateChange(argMap);
      } else if (call.method == SdkMethod.onReadLoveTapUser) {
        return _onReadLoveTapUser(argMap);
      } else if (call.method == SdkMethod.onLoveTapUserUpdate) {
        return _onLoveTapUserUpdate(argMap);
      } else if (call.method == SdkMethod.onLoveTapUserDelete) {
        return _onLoveTapUserDelete(argMap);
      } else if (call.method == SdkMethod.onReadMedicationReminder) {
        return _onReadMedicationReminder(argMap);
      } else if (call.method == SdkMethod.onMedicationReminderUpdate) {
        return _onMedicationReminderUpdate(argMap);
      } else if (call.method == SdkMethod.onMedicationReminderDelete) {
        return _onMedicationReminderDelete(argMap);
      } else if (call.method == SdkMethod.onLoveTapUpdate) {
        return _onLoveTapUpdate(argMap);
      } else if (call.method == SdkMethod.onReadUnit) {
        return _onReadUnit(argMap);
      } else if (call.method == SdkMethod.onReadDeviceInfo2) {
        return _onReadDeviceInfo2(argMap);
      } else if (call.method == SdkMethod.onReadHrMonitoringSettings) {
        return _onReadHrMonitoringSettings(argMap);
      } else if (call.method == SdkMethod.onDeviceConnecting) {
        return _onDeviceConnecting(argMap);
      } else if (call.method == SdkMethod.didUpdateANCSAuthorization) {
        return _didUpdateANCSAuthorization(argMap);
      } else if (call.method == SdkMethod.onReadBacklight) {
        return _onReadBacklight(argMap);
      } else if (call.method == SdkMethod.onReadHourSystem) {
        return _onReadHourSystem(argMap);
      }
      return;
    });
  }

  Future<void> _onDeviceConnected(Map map) async {
    BleLog.d("_onDeviceConnected $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onDeviceConnected(BleDevice.fromJson(map));
    }
  }

  Future<void> _onIdentityCreate(Map map) async {
    BleLog.d("_onIdentityCreate $map");
    bool status = map["status"];
    BleDeviceInfo? deviceInfo;
    Map? tmp = map["deviceInfo"];
    if (tmp != null) {
      deviceInfo = BleDeviceInfo.fromJson(tmp);
    }
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onIdentityCreate(status, deviceInfo);
    }
  }

  /// 设备主动返回解绑
  /// The device automatically returns to unbind
  Future<void> _onIdentityDelete(Map map) async {
    BleLog.d("_onIdentityDelete $map");

    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onIdentityDelete(map["status"]);
    }
  }

  /// 发送解绑指令的回调
  /// Callback for sending unbinding instruction
  Future<void> _onIdentityDeleteByDevice(Map map) async {
    BleLog.d("_onIdentityDeleteByDevice $map");

    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onIdentityDeleteByDevice(map["isDevice"]);
    }
  }

  Future<void> _onSessionStateChange(Map map) async {
    BleLog.d("_onSessionStateChange $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onSessionStateChange(map["status"]);
    }
  }

  Future<void> _onCommandReply(Map map) async {
    BleLog.d("_onCommandReply $map");
    int bleKey = map["bleKey"];
    int bleKeyFlag = map["bleKeyFlag"];
    bool status = map["status"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onCommandReply(
          BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag), status);
    }
  }

  Future<void> _onReadPower(Map map) async {
    BleLog.d("_onReadPower $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadPower(map["power"]);
    }
  }

  Future<void> _onReadFirmwareVersion(Map map) async {
    BleLog.d("_onReadFirmwareVersion $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadFirmwareVersion(map["version"]);
    }
  }

  Future<void> _onReadSedentariness(Map map) async {
    BleLog.d("_onReadSedentariness $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback
          .onReadSedentariness(BleSedentarinessSettings.fromJson(map));
    }
  }

  Future<void> _onReadNoDisturb(Map map) async {
    BleLog.d("_onReadNoDisturb $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadNoDisturb(BleNoDisturbSettings.fromJson(map));
    }
  }

  Future<void> _onNoDisturbUpdate(Map map) async {
    BleLog.d("_onNoDisturbUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onNoDisturbUpdate(BleNoDisturbSettings.fromJson(map));
    }
  }

  Future<void> _onReadAlarm(Map map) async {
    BleLog.d("_onReadAlarm $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadAlarm(BleAlarm.jsonToList(map));
    }
  }

  Future<void> _onAlarmUpdate(Map map) async {
    BleLog.d("_onAlarmUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onAlarmUpdate(BleAlarm.fromJson(map));
    }
  }

  Future<void> _onAlarmDelete(Map map) async {
    BleLog.d("_onAlarmDelete $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onAlarmDelete(map["id"]);
    }
  }

  Future<void> _onAlarmAdd(Map map) async {
    BleLog.d("_onAlarmAdd $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onAlarmAdd(BleAlarm.fromJson(map));
    }
  }

  Future<void> _onFindPhone(Map map) async {
    BleLog.d("_onFindPhone $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onFindPhone(map["start"]);
    }
  }

  Future<void> _onReadUiPackVersion(Map map) async {
    BleLog.d("_onReadUiPackVersion $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadUiPackVersion(map["version"]);
    }
  }

  Future<void> _onReadLanguagePackVersion(Map map) async {
    BleLog.d("_onReadLanguagePackVersion $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback
          .onReadLanguagePackVersion(BleLanguagePackVersion.fromJson(map));
    }
  }

  Future<void> _onSyncData(Map map) async {
    BleLog.d("_onSyncData $map");
    int syncState = map["syncState"];
    int bleKey = map["bleKey"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onSyncData(syncState, BleKey.of(bleKey));
    }
  }

  Future<void> _onReadActivity(Map map) async {
    BleLog.d("_onReadActivity $map");
    var list = BleActivity.jsonToList(map);
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadActivity(list);
    }
    if (isCacheActivity) {
      cacheActivity(list);
    }
  }

  Future<void> _onReadHeartRate(Map map) async {
    BleLog.d("_onReadHeartRate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadHeartRate(BleHeartRate.jsonToList(map));
    }
  }

  Future<void> _onUpdateHeartRate(Map map) async {
    BleLog.d("_onUpdateHeartRate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onUpdateHeartRate(BleHeartRate.fromJson(map));
    }
  }

  Future<void> _onReadBloodPressure(Map map) async {
    BleLog.d("_onReadBloodPressure $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadBloodPressure(BleBloodPressure.jsonToList(map));
    }
  }


  /// 读取到设备的睡眠数据
  Future<void> _onReadSleep(Map map) async {

    BleLog.d("_onReadSleep $map");

    // 转换睡眠数据对象
    List<BleSleep> blsSleeps = BleSleep.jsonToList(map);

    // 返回给上层回调方法
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadSleep(blsSleeps);
    }
  }

  Future<void> _onReadWorkout(Map map) async {
    BleLog.d("_onReadWorkout $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadWorkout(BleWorkout.jsonToList(map));
    }
  }

  Future<void> _onReadLocation(Map map) async {
    BleLog.d("_onReadLocation $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadLocation(BleLocation.jsonToList(map));
    }
  }

  Future<void> _onReadTemperature(Map map) async {
    BleLog.d("_onReadTemperature $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadTemperature(BleTemperature.jsonToList(map));
    }
  }

  Future<void> _onReadBloodOxygen(Map map) async {
    BleLog.d("_onReadBloodOxygen $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadBloodOxygen(BleBloodOxygen.jsonToList(map));
    }
  }

  Future<void> _onReadBleHrv(Map map) async {
    BleLog.d("_onReadBleHrv $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadBleHrv(BleHrv.jsonToList(map));
    }
  }

  Future<void> _onCameraStateChange(Map map) async {
    BleLog.d("_onCameraStateChange $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onCameraStateChange(map["cameraState"]);
    }
  }

  Future<void> _onCameraResponse(Map map) async {
    BleLog.d("_onCameraResponse $map");
    bool status = map["status"];
    int cameraState = map["cameraState"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onCameraResponse(status, cameraState);
    }
  }

  Future<void> _onStreamProgress(Map map) async {
    BleLog.d("_onStreamProgress $map");
    bool status = map["status"];
    int errorCode = map["errorCode"];
    int total = map["total"];
    int completed = map["completed"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onStreamProgress(status, errorCode, total, completed);
    }
  }

  Future<void> _onReadPressure(Map map) async {
    BleLog.d("_onReadPressure $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadPressure(BlePressure.jsonToList(map));
    }
  }

  Future<void> _onRequestLocation(Map map) async {
    BleLog.d("_onRequestLocation $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onRequestLocation(map["workoutState"]);
    }
  }

  Future<void> _onReadWorkout2(Map map) async {
    BleLog.d("_onReadWorkout2 $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadWorkout2(BleWorkout2.jsonToList(map));
    }
  }

  Future<void> _onCommandSendTimeout(Map map) async {
    BleLog.d("_onCommandSendTimeout $map");
    int bleKey = map["bleKey"];
    int bleKeyFlag = map["bleKeyFlag"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onCommandSendTimeout(
          BleKey.of(bleKey), BleKeyFlag.of(bleKeyFlag));
    }
  }

  Future<void> _onReadNotificationSettings2(Map map) async {
    int notification = map["mNotificationBits"];
    BleLog.d("flutter onReadNotificationSettings2 $notification");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadNotificationSettings2(notification);
    }
  }

  Future<void> _onReadDeviceInfo(Map map) async {
    BleLog.d("_onReadDeviceInfo $map");
    BleDeviceInfo? deviceInfo;
    Map? tmp = map["deviceInfo"];
    if (tmp != null) {
      deviceInfo = BleDeviceInfo.fromJson(tmp);
    }
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadDeviceInfo(deviceInfo!);
    }
  }

  Future<void> _onReadBleAddress(Map map) async {
    BleLog.d("_onReadBleAddress $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadBleAddress(map["address"]);
    }
  }

  Future<void> _onDeviceRequestAGpsFile(Map map) async {
    BleLog.d("_onDeviceRequestAGpsFile $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onDeviceRequestAGpsFile(map["url"]);
    }
  }

  Future<void> _onFollowSystemLanguage(Map map) async {
    BleLog.d("_onFollowSystemLanguage $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onFollowSystemLanguage(map["status"]);
    }
  }

  Future<void> _onReadDateFormat(Map map) async {
    BleLog.d("_onReadDateFormat $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadDateFormat(map["value"]);
    }
  }

  Future<void> _onReceiveMusicCommand(Map map) async {
    BleLog.d("_onReceiveMusicCommand $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReceiveMusicCommand(map["musicCommand"]);
    }
  }

  Future<void> _onReadTemperatureUnit(Map map) async {
    BleLog.d("_onReadTemperatureUnit $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadTemperatureUnit(map["value"]);
    }
  }

  Future<void> _onReadWeatherRealTime(Map map) async {
    BleLog.d("_onReadWeatherRealTime $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadWeatherRealTime(map["status"]);
    }
  }

  Future<void> _onVibrationUpdate(Map map) async {
    BleLog.d("_onVibrationUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onVibrationUpdate(map["value"]);
    }
  }

  Future<void> _onBacklightUpdate(Map map) async {
    BleLog.d("_onBacklightUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onBacklightUpdate(map["value"]);
    }
  }

  Future<void> _onReadGestureWake(Map map) async {
    BleLog.d("_onReadGestureWake $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadGestureWake(BleGestureWake.fromJson(map));
    }
  }

  Future<void> _onGestureWakeUpdate(Map map) async {
    BleLog.d("_onGestureWakeUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onGestureWakeUpdate(BleGestureWake.fromJson(map));
    }
  }

  Future<void> _onOTAProgress(Map map) async {
    BleLog.d("_onOTAProgress $map");
    double progress = map["progress"].toDouble();
    int otaStatus = map["otaStatus"];
    String error = map["error"];
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onOTAProgress(progress, otaStatus, error);
    }
  }

  Future<void> _onPowerSaveModeState(Map map) async {
    BleLog.d("_onPowerSaveModeState $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onPowerSaveModeState(map["state"]);
    }
  }

  Future<void> _onPowerSaveModeStateChange(Map map) async {
    BleLog.d("_onPowerSaveModeStateChange $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onPowerSaveModeStateChange(map["state"]);
    }
  }

  Future<void> _onReadLoveTapUser(Map map) async {
    BleLog.d("_onReadLoveTapUser $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadLoveTapUser(BleLoveTapUser.jsonToList(map));
    }
  }

  Future<void> _onLoveTapUserUpdate(Map map) async {
    BleLog.d("_onLoveTapUserUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onLoveTapUserUpdate(BleLoveTapUser.fromJson(map));
    }
  }

  Future<void> _onLoveTapUserDelete(Map map) async {
    BleLog.d("_onLoveTapUserDelete $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onLoveTapUserDelete(map["id"]);
    }
  }

  Future<void> _onReadMedicationReminder(Map map) async {
    BleLog.d("_onReadMedicationReminder $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback
          .onReadMedicationReminder(BleMedicationReminder.jsonToList(map));
    }
  }

  Future<void> _onMedicationReminderUpdate(Map map) async {
    BleLog.d("_onMedicationReminderUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback
          .onMedicationReminderUpdate(BleMedicationReminder.fromJson(map));
    }
  }

  Future<void> _onMedicationReminderDelete(Map map) async {
    BleLog.d("_onMedicationReminderDelete $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onMedicationReminderDelete(map["id"]);
    }
  }

  Future<void> _onLoveTapUpdate(Map map) async {
    BleLog.d("_onLoveTapUpdate $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onLoveTapUpdate(BleLoveTap.fromJson(map));
    }
  }

  Future<void> _onReadUnit(Map map) async {
    BleLog.d("_onReadUnit $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadUnit(map["value"]);
    }
  }

  Future<void> _onReadDeviceInfo2(Map map) async {
    BleLog.d("_onReadDeviceInfo2 $map");
    BleDeviceInfo2? deviceInfo;
    Map? tmp = map["deviceInfo"];
    if (tmp != null) {
      deviceInfo = BleDeviceInfo2.fromJson(tmp);
    }
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadDeviceInfo2(deviceInfo!);
    }
  }

  Future<void> _onReadHrMonitoringSettings(Map map) async {
    BleLog.d("_onReadHrMonitoringSettings $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadHrMonitoringSettings(BleHrMonitoringSettings.fromJson(map));
    }
  }

  Future<void> _onDeviceConnecting(Map map) async {
    BleLog.d("_onDeviceConnecting $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onDeviceConnecting(map["status"]);
    }
  }

  Future<void> _didUpdateANCSAuthorization(Map map) async {
    BleLog.d("_didUpdateANCSAuthorization $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.didUpdateANCSAuthorization(map["status"]);
    }
  }

  Future<void> _onReadBacklight(Map map) async {
    BleLog.d("_onReadBacklight $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadBacklight(map["value"]);
    }
  }

  Future<void> _onReadHourSystem(Map map) async {
    BleLog.d("_onReadHourSystem $map");
    for (var bleHandleCallback in _bleHandleCallbacks) {
      bleHandleCallback.onReadHourSystem(map["value"]);
    }
  }
}
