import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

abstract class BleHandleCallback {
  ///设备连接成功时触发。
  void onDeviceConnected(BleDevice device) {}

  ///绑定时触发。
  void onIdentityCreate(bool status, BleDeviceInfo? deviceInfo) {}

  ///解绑时触发。有些设备解绑会触发，但有些不会。
  void onIdentityDelete(bool status) {}

  ///设备主动解绑时触发。例如设备恢复出厂设置
  void onIdentityDeleteByDevice(bool isDevice) {}

  ///连接状态变化时触发。
  void onSessionStateChange(bool status) {}

  ///设备回复某些指令时触发。
  void onCommandReply(BleKey bleKey, BleKeyFlag bleKeyFlag, bool status) {}

  ///设备返回电量时触发。
  void onReadPower(int power) {}

  ///设备返回固件版本时触发。
  void onReadFirmwareVersion(String version) {}

  ///设备返回mac地址时触发。
  void onReadBleAddress(String address) {}

  ///设备返回久坐设置时触发。
  void onReadSedentariness(BleSedentarinessSettings sedentarinessSettings) {}

  ///设备返回勿扰设置时触发。
  void onReadNoDisturb(BleNoDisturbSettings noDisturbSettings) {}

  ///设备端修改勿扰设置时触发。
  void onNoDisturbUpdate(BleNoDisturbSettings noDisturbSettings) {}

  ///设备返回闹钟列表时触发。
  void onReadAlarm(List<BleAlarm> alarms) {}

  ///设备端修改闹钟时触发。
  void onAlarmUpdate(BleAlarm alarm) {}

  ///设备端删除闹钟时触发。
  void onAlarmDelete(int id) {}

  ///设备端创建闹钟时触发。
  void onAlarmAdd(BleAlarm alarm) {}

  ///当设备发起找手机触发。
  void onFindPhone(bool start) {}

  /// 设备返回UI包版本时触发。
  void onReadUiPackVersion(String version) {}

  ///设备返回语言包信息时触发。
  void onReadLanguagePackVersion(BleLanguagePackVersion version) {}

  ///同步数据时触发。
  /// syncState [SyncState]
  /// bleKey [BleKey]
  void onSyncData(int syncState, BleKey bleKey) {}

  ///当设备返回[BleActivity]时触发。
  void onReadActivity(List<BleActivity> activities) {}

  ///发送读取命令后，设备返回[BleHeartRate]时触发。
  void onReadHeartRate(List<BleHeartRate> heartRates) {}

  ///当设备主动更新[BleHeartRate]时触发。
  void onUpdateHeartRate(BleHeartRate heartRate) {}

  ///当设备返回[BleBloodPressure]时触发。
  void onReadBloodPressure(List<BleBloodPressure> bloodPressures) {}

  ///当设备返回[BleSleep]时触发。
  void onReadSleep(List<BleSleep> sleeps) {}

  ///当设备返回[BleWorkout]时触发。
  void onReadWorkout(List<BleWorkout> workouts) {}

  ///当设备返回[BleLocation]时触发。
  void onReadLocation(List<BleLocation> locations) {}

  ///当设备返回[BleTemperature]时触发。
  void onReadTemperature(List<BleTemperature> temperatures) {}

  ///当设备返回[BleBloodOxygen]时触发。
  void onReadBloodOxygen(List<BleBloodOxygen> bloodOxygen) {}

  ///当设备返回[BleHrv]时触发。
  void onReadBleHrv(List<BleHrv> hrv) {}

  ///设备主动执行拍照相关操作时触发。
  /// cameraState [CameraState]
  void onCameraStateChange(int cameraState) {}

  ///手机执行拍照相关操作，设备回复时触发。
  ///手机发起后设备响应。用于确认设备是否能立即响应手机发起的操作，比如设备在某些特定界面是不能进入相机的，
  ///如果手机发起进入相机指令，设备会回复失败
  /// cameraState [CameraState]
  void onCameraResponse(bool status, int cameraState) {}

  ///调用[BleConnector.sendFile]后触发，用于回传发送进度。
  /// mErrorCode error type
  /// 0: Transmission successful
  /// 1: The file type is not supported
  /// 2: File size problem, file size exceeds local storage space
  /// 4: The current state does not support transmission, such as making phone calls, charging, measuring heart rate....
  /// 5: Flash read and write error
  void onStreamProgress(bool status, int errorCode, int total, int completed) {}

  ///设备请求定位时触发，一些无Gps设备在锻炼时会请求手机定位。
  /// workoutState [WorkoutState]
  void onRequestLocation(int workoutState) {}

  ///设备开启Gps时，如果检测到没有aGps文件，或aGps文件已过期，设备发起请求aGps文件
  /// url aGps文件的下载链接
  void onDeviceRequestAGpsFile(String url) {}

  ///当设备控制来电时触发。  0 -接听 ； 1-拒接
  void onIncomingCallStatus(int status) {}

  ///当设备返回[BlePressure]时触发。
  void onReadPressure(List<BlePressure> pressures) {}

  ///设备语言设置选择跟随手机时触发
  void onFollowSystemLanguage(bool status) {}

  ///设备端主动请求读取天气数据
  void onReadWeatherRealTime(bool status) {}

  ///当设备返回[BleWorkout2]时触发。
  void onReadWorkout2(List<BleWorkout2> workouts) {}

  ///设备发送某条指令超时触发。
  void onCommandSendTimeout(BleKey bleKey, BleKeyFlag bleKeyFlag) {}

  ///读取iOS消息推送列表回调
  void onReadNotificationSettings2(int notification) {}

  ///当读取设备信息时返回
  void onReadDeviceInfo(BleDeviceInfo deviceInfo) {}

  ///返回当前设备温度单位
  void onReadTemperatureUnit(int value) {}

  ///返回当前设备日期格式
  void onReadDateFormat(int value) {}

  ///设备端修改震动设置时触发, 返回次数
  void onVibrationUpdate(int value) {}

  ///设备端修改背光设置时触发, 返回次数
  void onBacklightUpdate(int value) {}

  ///设备返回翻腕亮屏设置时触发。
  void onReadGestureWake(BleGestureWake gestureWake) {}

  ///设备端修改翻腕亮屏设置时触发。
  void onGestureWakeUpdate(BleGestureWake gestureWake) {}

  ///设备点击音乐相关按键时触发
  ///musicCommand [MusicCommand]
  void onReceiveMusicCommand(int musicCommand) {}

  ///调用[startOTA]后触发，ota进度状态。
  ///otaStatus [OTAStatus]
  void onOTAProgress(double progress, int otaStatus, String error) {}

  ///设备返回当前省电模式状态时触发。
  ///state [PowerSaveModeState]
  void onPowerSaveModeState(int state) {}

  ///设备的省电模式状态变化时触发。
  ///state [PowerSaveModeState]
  void onPowerSaveModeStateChange(int state) {}

  ///设备返回LoveTap用户列表时触发。
  void onReadLoveTapUser(List<BleLoveTapUser> loveTapUsers) {}

  ///设备端修改LoveTap用户时触发。
  void onLoveTapUserUpdate(BleLoveTapUser loveTapUser) {}

  ///设备端删除LoveTap用户时触发。
  void onLoveTapUserDelete(int id) {}

  ///设备返回吃药提醒列表时触发。
  void onReadMedicationReminder(
      List<BleMedicationReminder> medicationReminders) {}

  ///设备端修改吃药提醒时触发。
  void onMedicationReminderUpdate(BleMedicationReminder medicationReminder) {}

  ///设备端删除吃药提醒时触发。
  void onMedicationReminderDelete(int id) {}

  ///设备返回LoveTap数据时触发。
  void onLoveTapUpdate(BleLoveTap loveTap) {}

  ///返回当前设备公英制单位
  void onReadUnit(int value) {}

  ///当读取设备信息时返回
  void onReadDeviceInfo2(BleDeviceInfo2 deviceInfo) {}

  ///设备返回心率设置时触发。
  void onReadHrMonitoringSettings(BleHrMonitoringSettings hrMonitoringSettings) {}

  ///正在连接中时触发
  void onDeviceConnecting(bool status) {}

  /// iOS返回ANCS状态时触发, 请注意这个仅仅在iOS 13.0或者更高版本才支持
  void didUpdateANCSAuthorization(bool status) {}

  ///读取设备端背光设置时触发
  void onReadBacklight(int value) {}

  ///读取设备端小时制设置时触发
  void onReadHourSystem(int value) {}
}
