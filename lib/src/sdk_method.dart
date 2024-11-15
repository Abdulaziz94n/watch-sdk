class SdkMethod {
  /// BleScanner methods
  static const String build = "build";
  static const String scan = "scan";
  static const String exit = "exit";

  /// BleScanCallback method
  static const String onBluetoothDisabled = "onBluetoothDisabled";
  static const String onScan = "onScan";
  static const String onDeviceFound = "onDeviceFound";
  // iOS平台才会使用到的方法, 用于检索已连接的外设; A method only used by the iOS platform to retrieve connected peripherals
  static const String onRetrieveConnectedPeripherals = "onRetrieveConnectedPeripherals";
  // iOS平台才会使用到的方法, 用于返回当前连接的设备UUID字符串, 如果没有连接或者执行失败, 将返回空字符串
  // The method only used by the iOS platform is used to return the UUID string of the currently connected device. If there is no connection or the execution fails, an empty string will be returned
  static const String onRetrieveConnectedDeviceUUID = "onRetrieveConnectedDeviceUUID";

  /// BleConnector methods
  static const String init = "init";
  static const String sendData = "sendData";
  static const String sendBoolean = "sendBoolean";
  static const String sendInt8 = "sendInt8";
  static const String sendInt16 = "sendInt16";
  static const String sendInt32 = "sendInt32";
  static const String sendObject = "sendObject";
  static const String sendStream = "sendStream";
  static const String connectClassic = "connectClassic";
  static const String launch = "launch";
  static const String unbind = "unbind";
  static const String isBound = "isBound";
  static const String isAvailable = "isAvailable";
  static const String setAddress = "setAddress";
  static const String connect = "connect";
  static const String closeConnection = "closeConnection";
  static const String startOTA = "startOTA";
  static const String releaseOTA = "releaseOTA";
  static const String startMusicController = "startMusicController";
  static const String stopMusicController = "stopMusicController";
  static const String saveLogs = "saveLogs";
  static const String iBeaconListening = "iBeaconListening";
  static const String isOpenLoveTapPush = "isOpenLoveTapPush"; // 用于开启LoveTap测试推送
  static const String killApp = "killApp"; // 主要用于iOS测试iBeacon
  static const String setPhoneStateListener = "setPhoneStateListener"; //安卓系统来电状态监听设置
  static const String setDataKeyAutoDelete = "setDataKeyAutoDelete";
  static const String isConnecting = "isConnecting";
  static const String isMusicControllerRunning = "isMusicControllerRunning";
  static const String sendMusicPlayState = "sendMusicPlayState";
  static const String sendMusicTitle = "sendMusicTitle";
  static const String sendPhoneVolume = "sendPhoneVolume";

  /// BleHandleCallback methods
  static const String onDeviceConnected = "onDeviceConnected";
  static const String onIdentityCreate = "onIdentityCreate";
  static const String onIdentityDelete = "onIdentityDelete";
  static const String onIdentityDeleteByDevice = "onIdentityDeleteByDevice";
  static const String onSessionStateChange = "onSessionStateChange";
  static const String onCommandReply = "onCommandReply";
  static const String onReadPower = "onReadPower";
  static const String onReadFirmwareVersion = "onReadFirmwareVersion";
  static const String onReadSedentariness = "onReadSedentariness";
  static const String onReadNoDisturb = "onReadNoDisturb";
  static const String onNoDisturbUpdate = "onNoDisturbUpdate";
  static const String onReadAlarm = "onReadAlarm";
  static const String onAlarmUpdate = "onAlarmUpdate";
  static const String onAlarmDelete = "onAlarmDelete";
  static const String onAlarmAdd = "onAlarmAdd";
  static const String onFindPhone = "onFindPhone";
  static const String onReadUiPackVersion = "onReadUiPackVersion";
  static const String onReadLanguagePackVersion = "onReadLanguagePackVersion";
  static const String onSyncData = "onSyncData";
  static const String onReadActivity = "onReadActivity";
  static const String onReadHeartRate = "onReadHeartRate";
  static const String onUpdateHeartRate = "onUpdateHeartRate";
  static const String onReadBloodPressure = "onReadBloodPressure";
  static const String onReadSleep = "onReadSleep";
  static const String onReadWorkout = "onReadWorkout";
  static const String onReadLocation = "onReadLocation";
  static const String onReadTemperature = "onReadTemperature";
  static const String onReadBloodOxygen = "onReadBloodOxygen";
  static const String onReadBleHrv = "onReadBleHrv";
  static const String onCameraStateChange = "onCameraStateChange";
  static const String onCameraResponse = "onCameraResponse";
  static const String onStreamProgress = "onStreamProgress";
  static const String onRequestLocation = "onRequestLocation";
  static const String onDeviceRequestAGpsFile = "onDeviceRequestAGpsFile";
  static const String onIncomingCallStatus = "onIncomingCallStatus";
  static const String onReadPressure = "onReadPressure";
  static const String onFollowSystemLanguage = "onFollowSystemLanguage";
  static const String onReadWeatherRealTime = "onReadWeatherRealTime";
  static const String onReadWorkout2 = "onReadWorkout2";
  static const String onCommandSendTimeout = "onCommandSendTimeout";
  static const String onOTAProgress = "onOTAProgress";
  static const String onReadNotificationSettings2 = "onReadNotificationSettings2";
  static const String onReadDeviceInfo = "onReadDeviceInfo";
  static const String onReadBleAddress = "onReadBleAddress";
  static const String onReceiveMusicCommand = "onReceiveMusicCommand";
  static const String onReadTemperatureUnit = "onReadTemperatureUnit";
  static const String onReadDateFormat = "onReadDateFormat";
  static const String onVibrationUpdate = "onVibrationUpdate";
  static const String onBacklightUpdate = "onBacklightUpdate";
  static const String onReadGestureWake = "onReadGestureWake";
  static const String onGestureWakeUpdate = "onGestureWakeUpdate";
  static const String onReadLoveTapUser = "onReadLoveTapUser";
  static const String onPowerSaveModeState = "onPowerSaveModeState";
  static const String onPowerSaveModeStateChange = "onPowerSaveModeStateChange";
  static const String onLoveTapUserUpdate = "onLoveTapUserUpdate";
  static const String onLoveTapUserDelete = "onLoveTapUserDelete";
  static const String onReadMedicationReminder = "onReadMedicationReminder";
  static const String onMedicationReminderUpdate = "onMedicationReminderUpdate";
  static const String onMedicationReminderDelete = "onMedicationReminderDelete";
  static const String onLoveTapUpdate = "onLoveTapUpdate";
  static const String onReadUnit = "onReadUnit";
  static const String onReadDeviceInfo2 = "onReadDeviceInfo2";
  static const String onReadHrMonitoringSettings = "onReadHrMonitoringSettings";
  static const String onDeviceConnecting = "onDeviceConnecting";
  static const String didUpdateANCSAuthorization = "didUpdateANCSAuthorization";
  static const String onReadBacklight = "onReadBacklight";
  static const String onReadHourSystem = "onReadHourSystem";
}
