//
//  SdkMethod.swift
//  coding_dev_flutter_sdk
//
//  Created by SMA-IOS on 2022/6/9.
//

import Foundation

let _channelPrefix = "com.sma.ble"
// BleScanner methods
let mBleScannerBuild = "build"
let mBleScannerScan = "scan"
let mBleScannerExit = "exit"

// BleScanCallback method
let BleScanBluetoothDisabled = "onBluetoothDisabled"
let BleScanOnScan = "onScan"
let BleScanDeviceFound = "onDeviceFound"

// BleConnector methods
let initBleConnector = "init"
let sendData = "sendData"
let sendBoolean = "sendBoolean"
let sendObject = "sendObject"
let sendStream = "sendStream"
let connectClassic = "connectClassic"
let unbind = "unbind"
let isBound = "isBound"
let isAvailable = "isAvailable"
let connect = "connect"
let closeConnection = "closeConnection"

// BleHandleCallback methods
let callBackDeviceConnected = "onDeviceConnected"
//let callBackIdentityCreate = "onIdentityCreate"
let callBackIdentityDelete = "onIdentityDelete"
let callBackIdentityDeleteByDevice = "onIdentityDeleteByDevice"
let callBackSessionStateChange = "onSessionStateChange"
let callBackCommandReply = "onCommandReply"
let callBackReadPower = "onReadPower"
let callBackReadFirmwareVersion = "onReadFirmwareVersion"
let callBackReadSedentariness = "onReadSedentariness"
let callBackNoDisturbUpdate = "onNoDisturbUpdate"
let callBackReadAlarm = "onReadAlarm"
let callBackAlarmUpdate = "onAlarmUpdate"
let callBackAlarmDelete = "onAlarmDelete"
let callBackAlarmAdd = "onAlarmAdd"
let callBackFindPhone = "onFindPhone"
let callBackReadUiPackVersion = "onReadUiPackVersion"
let callBackReadLanguagePackVersion = "onReadLanguagePackVersion"
let callBackSyncData = "onSyncData"
let callBackReadActivity = "onReadActivity"
let callBackReadHeartRate = "onReadHeartRate"
let callBackUpdateHeartRate = "onUpdateHeartRate"
let callBackReadBloodPressure = "onReadBloodPressure"
let callBackReadSleep = "onReadSleep"
let callBackReadWorkout = "onReadWorkout"
let callBackReadLocation = "onReadLocation"
let callBackReadTemperature = "onReadTemperature"
//let callBackReadBloodOxygen = "onReadBloodOxygen"
let callBackReadBleHrv = "onReadBleHrv"
let callBackCameraStateChange = "onCameraStateChange"
let callBackCameraResponse = "onCameraResponse"
let callBackStreamProgress = "onStreamProgress"
let callBackRequestLocation = "onRequestLocation"
let callBackDeviceRequestAGpsFile = "onDeviceRequestAGpsFile"
let callBackIncomingCallStatus = "onIncomingCallStatus"
let callBackReadPressure = "onReadPressure"
let callBackFollowSystemLanguage = "onFollowSystemLanguage"
let callBackReadWeatherRealTime = "onReadWeatherRealTime"
//let callBackReadWorkout2 = "onReadWorkout2"
let callBackCommandSendTimeout = "onCommandSendTimeout"



// 2022-11-17 新增方法
enum SdkMethod: String {
    
    /// 初始化SDK
    case launch = "launch"
    
    /// iOS平台才会使用到的方法, 用于检索已连接的外设; A method only used by the iOS platform to retrieve connected peripherals
    case onRetrieveConnectedPeripherals = "onRetrieveConnectedPeripherals"
    
    /// iOS平台才会使用到的方法, 用于返回当前连接的设备UUID字符串, 如果没有连接或者执行失败, 将返回空字符串
    /// The method only used by the iOS platform is used to return the UUID string of the currently connected device. If there is no connection or the execution fails, an empty string will be returned
    case onRetrieveConnectedDeviceUUID = "onRetrieveConnectedDeviceUUID"
    
    // BleConnector methods
    case sendInt8 = "sendInt8"
    case sendInt16 = "sendInt16"
    case sendInt32 = "sendInt32"
    
    
    /// 设置UUID
    case setAddress = "setAddress"
    
    // BleHandleCallback methods
    
    /// 绑定设备
    case onIdentityCreate = "onIdentityCreate"
    /// 设备连接中
    case onDeviceConnecting = "onDeviceConnecting"
    /// 返回设备的ANCS状态回调
    case didUpdateANCSAuthorization = "didUpdateANCSAuthorization"
    
    /// 读取设备信息返回
    case onReadDeviceInfo = "onReadDeviceInfo"
    /// 读取设备 BleAddress
    case onReadBleAddress = "onReadBleAddress"
    /// 读取设备 温度设置单位
    case onReadTemperatureUnit = "onReadTemperatureUnit"
    /// 读取日期设置格式
    case onReadDateFormat = "onReadDateFormat"
    
    /// 读取震动提醒
    case onVibrationUpdate = "onVibrationUpdate"
    
    
    /// 设备返回当前抬手亮屏设置状态时触发
    case onReadGestureWake = "onReadGestureWake"
    /// 设备的抬手亮屏设置状态变化时触发
    case onGestureWakeUpdate = "onGestureWakeUpdate"
    
    /// 读取小时制
    case onReadHourSystem = "onReadHourSystem"
    /// 设备上更新了小时制的回调
    case onHourSystemUpdate = "onHourSystemUpdate"
    
    /// 读取背光
    case onReadBacklight = "onReadBacklight"
    /// 设备端修改背光设置时触发
    case onBacklightUpdate = "onBacklightUpdate"
    
    
    /// 设备返回当前省电模式状态时触发
    case onPowerSaveModeState = "onPowerSaveModeState"
    /// 设备的省电模式状态变化时触发
    case onPowerSaveModeStateChange = "onPowerSaveModeStateChange"
    
    
    /// 设备返回LoveTap 用户列表时触发
    case onReadLoveTapUser = "onReadLoveTapUser"
    /// 设备端修改LoveTap用户时触发
    case onLoveTapUserUpdate = "onLoveTapUserUpdate"
    /// 设备端删除LoveTap用户时触发
    case onLoveTapUserDelete = "onLoveTapUserDelete"
    
    /// 设备返回LoveTap 数据触发
    case onLoveTapUpdate = "onLoveTapUpdate"
    
    
    
    /// 设备返回吃药提醒列表时触发
    case onReadMedicationReminder = "onReadMedicationReminder"
    /// 设备端修改吃药提醒时触发
    case onMedicationReminderUpdate = "onMedicationReminderUpdate"
    /// 设备端删除吃药提醒时触发
    case onMedicationReminderDelete = "onMedicationReminderDelete"
    /// 读取单位设置
    case onReadUnit = "onReadUnit"
    /// 手表信息, 设备基础信息返回
    case onReadDeviceInfo2 = "onReadDeviceInfo2"
    /// 读取心率设置
    case onReadHrMonitoringSettings = "onReadHrMonitoringSettings"

    
    // 读取勿扰数据
    case onReadNoDisturb = "onReadNoDisturb"
    case onReadBloodOxygen = "onReadBloodOxygen"
    
    //MARK: 02 Set 类方法
    case onReadWorkout2 = "onReadWorkout2"

    /// 返回消息提醒开关方法
    case onReadNotificationSettings2 = "onReadNotificationSettings2"
    
    //MARK: iBeacon相关
    /// 用于处理开启, 关闭 iBeacon 的监听
    case iBeaconListening
    case isOpenLoveTapPush
    case killApp
    
    /**
     Realtek瑞昱 OTA 相关的数据
     */
    case startOTA = "startOTA"
    case releaseOTA = "releaseOTA"
    case onOTAProgress = "onOTAProgress"


    // 用于设置, 当前是否自动在读取记录数据后, 自动删除执行一次删除指令, 删除读取完成的数据
    case setDataKeyAutoDelete = "setDataKeyAutoDelete"

}

var scannerResult : FlutterMethodChannel?
var bleConnectorResult : FlutterMethodChannel?






// MARK OTA升级, 状态码
enum OTAStatus: Int {
    
    ///ota前有些预操作，如先扫描，再连接，连接成功才开始升级
    case OTA_PREPARE = 1
    
    ///ota前准备工作失败
    case OTA_PREPARE_FAILED = 2
    
    ///ota开始
    case OTA_START = 3
    
    ///ota文件校验中, 杰里平台需要先校验文件后才开始升级
    case OTA_CHECKING = 4
    
    ///ota升级中
    case OTA_UPGRADEING = 5
    
    ///ota完成
    case OTA_DONE = 6
    
    ///ota失败
    case OTA_FAILED = 7
    
    ///未知
    case UNKNOWN = -1
}

