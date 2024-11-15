## 1.Process
![Process](https://sma_care.coding.net/p/image_collection/d/image_collection/git/raw/master/device_operation_flow_en.png)
1. Scan the BLE device nearby.
2. Connect to target device.
3. Request binding.
4. Confirm binding on device.
5. Request logging in.
6. Two-way communication with device.
7. Unbind with device.

> Binding and logging in are determined by framework, and will be dealt with automatically. If a device has been bound already, scanning and binding will be skipped.

## 2. Usage
#### (1)Initialization

In `main()`：
```
BleConnector.getInstance.init();
```

#### (2)Scanner
1. Declare a `Scanner`
```
BleScanner mBleScanner = BleScanner(const Duration(seconds: 10), this);

@override
void onBluetoothDisabled() {
  // Mobile Bluetooth is not enabled
}

@override
void onDeviceFound(BleDevice device) {
  // Device was searched
}

@override
void onScan(bool scan) {
  // Scan started or finished
}

```
2. Start scanning
```
mBleScanner.scan(true)
```
Because discoverable devices might reveal information about the user's location, the device discovery process requires location access, and the location service needs to be enabled on some mobile phones, otherwise the device cannot be searched. If the mobile phone's Bluetooth is on, `onScan(true)` will be triggered, otherwise `onBluetoothDisabled()` will be triggered, and `onDeviceFound(device)` will be triggered when a matching device is scanned. After the specified scanDuration time, the scan will automatically stop, you can also call `mBleScanner.scan(false)` to stop manually, and it will trigger `onScan(false)` when stopping.

3. Exit scanning

When the user interface is destroyed, call `mBleScanner.exit()` to exit the scanning to prevent memory leaks.

---
#### (3)Connection

After searching for the target device, connect to the device with the following code:
```
BleConnector.getInstance.setAddress(mAddress);
BleConnector.getInstance.connect(true);
```
---
#### (4)Binding/Logging in

After the connection is established, the framework will automatically send a binding or logging in command to the device according to the status.
1. If no device bound, the binding command will be sent first. After the device confirms pairing, the device-related information will be saved and then send the logging in command.
2. If a device has been bound already, just only send logging in command directly.

After login successfully, you can communicate with the device.

---
#### (5)Sending message to device

The way current protocol used for communication is called send/reply, and the replying is processed by the framework, we just only need to care about sending. The main way to send a message is to call the method whose name are started with 'send' in the BleConnector object：

| Method Name               | Description                                                                                                                                                                 |
|:--------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sendData()                | Send a BleyKey and send a BleKeyFlag                                                                                                                                        |
| sendBoolean(Boolean)      | Send a Boolean value, the Boolean value will be converted into an array containing only one byte, true becomes 1, false becomes 0                                           |
| sendInt8(Int)             | Send a Int value, only the lower 8 bits are valid, according to different commands, device parses it into an unsigned integer(0 ~ 0xff) or a signed integer(-0x80～0x7f)    |
| sendInt32(Int)            | Send a Int value, device parses it into an unsigned integer(0 ~ 0xffffffff) or a signed integer(-0x80000000～0x7fffffff)                                                    |
| sendObject(BleBase)       | Send a BleBase object                                                                                                                                                               |
| sendStream(File)          | Send a File                                                                                                                                                               |

Some special methods:

| Method Name                                | Description                                                                                                                                                                                       |
|:-------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sendData(BleKey.DATA_ALL, BleKeyFlag.READ) | BleKey.DATA_ALL It is not a real command, it is just a special mark. When the framework encounters this command, it will automatically read all the data supported by the currently bound device. |

---
#### (6)Events callback
It will trigger a event when device reply or send a command. These events are dispatched on the main thread through `BleHandleCallback`. Register an event callback through `BleConnector.getInstance.addHandleCallback(BleHandleCallback)` at any place where the event needs to be processed, and you can receive the corresponding event.
> If the callback interface is registered in the UI component, you should call `BleConnector.getInstance.removeHandleCallback(BleHandleCallback)` to remove the callback interface when the UI component gets destroyed, otherwise it will cause a memory leak.


## 4. Common Data Instructions
#### Instruction for Comand Classification
After running the SDK and binding the device, the device function list page will be displayed and all the contents of the list can be found in the class `BleKey`

#### Instruction for Device Binding Information
After binding the device, you can see the basic information supported by the device through the `LogCat` in `Android Studio`, for example:
```
com.szabh.androidblesdk3 V/BaseBle: BleConnector handleData onIdentityCreate -> true, BleDeviceInfo(mId=0xE47307E9, mDataKeys=[0x05FF_DATA_ALL, 0x0502_ACTIVITY, 0x0503_HEART_RATE, 0x0504_LEName = PERName=050' PRESSAURE, 0x0505', 0x0504_LE, mBOOD_FURE_S, 0x0502, :45:6D:B9:C5', mPlatform='Realtek', mPrototype='SMA-F2', mFirmwareFlag='SmartWatch101', mAGpsType=0, mIOBufferSize=0, mWatchFaceType=3, mClassicAddress='', mHideDigitalPower=1 , mHideAntiLost=0)
```

Among them:
+ mDataKeys data supported by the device, please refer to the class `BleKey` for specific details
  + 0x05FF_DATA_ALL A special mark made up by App itself, referring to all data supported by the current device.
  + 0x0502_ACTIVITY It contains steps\calories\distance, please refer to the class `BleActivity`,
  + 0x0503_HEART_RATE Heart rate, please refer to class `BleHeartRate`
  + 0x0504_BLOOD_PRESSURE blood pressure, please refer to class `BleBloodPressure`
  + 0x0505_SLEEP sleep, please refer to class `BleSleep`
  + 0x0508_TEMPERATURE body temperature, please refer to class `BleTemperature`
+ mBleName Device Bluetooth name
+ mBleAddress Device Ble's Mac address
+ mPlatform device platform, please refer to class `BleDeviceInfo` for specific details
  + Realtek
  + MTK
  + Nordic
  + Goodix
+ mPrototype device prototype, please refer to the class `BleDeviceInfo`
+ mFirmwareFlag device firmware version flag, which is a private definition and will be used in online OTA
+ mAGpsType GPS tag, please refer to class `BleDeviceInfo`
+ mIOBufferSize currently does not need to use this parameter
+ Watchface type supported by mWatchFaceType, please refer to the class `BleDeviceInfo`
+ mClassicAddress If the device supports class Bluetooth, this parameter will contain the MAC address of class Bluetooth
+ mHideDigitalPower Whether to display the power number, please refer to the class `BleDeviceInfo`
+ Does mHideAntiLost support the anti-lost switch setting function? All devices have the anti-lost function by default, but whether this function can be switched on or off requires firmware support to control it. For details, please refer to the class `BleDeviceInfo`

## 4. FAQ

### (1) How to get data (including current and historical data), including steps, heart rate, sleep, etc.?

+ Bind device
+ Open the `Logcat` tool
+ Click 0x05_DATA -> 0x05FF_DATA_ALL -> 0x10_READ function
+ Check the log displayed by `Logcat`


Using the above operations, you can get all the unsynchronized data, which will contain all the unsynchronized data previously recorded by the device, including steps, heart rate, sleep, etc. The specific data types are subject to device support, and you can refer to the `BleDeviceInfo` information returned when the device is bound.

Please note that after the data is read, the App will automatically send a delete command to the device to delete the read data. Only when the data that has been read is deleted, can it continue to read the new data in the next stage.

If the data content you expected is not read, and the expected data cannot be read even after repeated testing, you can contact us and we will assist you in using this function.

### (2) How to prevent data from being deleted after reading?
Based on the test item, you can search the code of `sendData(bleKey, BleKeyFlag.DELETE)` globally in the class `BleConnector`, and then temporarily block it.

The meaning of this line of code is as follows:

    The existing data synchronization mechanism is: App sends a read data instruction -> the device returns data after receiving the read data instruction -> App receives the data and automatically sends a delete instruction to the device -> after the device receives the delete instruction Delete the sent data, prepare new unsent data, prepare for the next data read

Based on the above premise, in the existing code, after the data is successfully read, the App will automatically send the delete instruction to delete the read data, and then send the read data instruction again, so as to realize the cycle of reading the next data until the data is read completely. If you do not delete the read data, the App always reads the same set of data.

### (3) How to get hourly step data?
Need to confirm that the device supports automatic storage of hourly step data.
No matter whether it is supported or not, the App can read the step count data existing on the device through `0x05FF_DATA_ALL` or a separate `0x0502_ACTIVITY`.

### (4) How many days can the bracelet data be stored?
The storage time depends on the user's usage habits. Users who exercise more frequently have more data records and the storage space of the device is fixed.
The device will delete data only under the following conditions:
+ Received delete data command
+ When the storage space is full, the first stored data will be deleted automatically

Based on the above situation, we recommend that users should synchronize their data every 3 to 4 days, and the maximum time should not exceed 7 days to avoid previous data loss.

### (5) How to get real-time steps, heart rate, and body temperature?
You can use `0x05FF_DATA_ALL` or use `0x0502_ACTIVITY`, `0x0503_HEART_RATE`, `0x0508_TEMPERATURE` to obtain the current stored steps, heart rate, and body temperature data of the device.

Among them, the number of steps is real-time data.

Heart rate and body temperature data are the data stored after the last measurement of the device.

The timing detection time can be set through the classes `BleHrMonitoringSettings` and `BleTemperatureDetecting` to ensure that the data is automatically measured, updated, and recorded for subsequent synchronization of the App.

If the timing measurement setting is invalid, the device supports automatic detection around the clock without setting the detection interval separately.

It depends on the specific hardware device.

### (6) Does sleep monitoring need to be opened separately?
No, this function is default enabled for all devices.

### (7) What is the basic definition of sleep detection?
From 10 pm to 4 am the next day, the device will automatically detect whether the user falls asleep or not;
Only the end of sleep state will be detected after 4 am the next day.

The verified and more general calculation logic on the App is as follows:
+ Synchronize device sleep data and store the obtained data in the database
+ In the database, in the order of the sleep data recording time ASC, read all the sleep record details from 12 o'clock yesterday to 12 noon today, for example, the time is January 12, January 13 (today); then In order to obtain sleep data on the night of January 12, the value range is from 12:00 noon on January 12 to 12:00 noon on January 13 all sleep data records.
+ After obtaining the data record, you can directly analyze the sleep data through the `BleSleep.analyseSleep` method. The analyzed data can be used to customize the drawing chart, and the data drawn by our App comes from this.
+ The data obtained in the previous step can be further used to calculate the time of different sleep states through the `BleSleep.getSleepStatusDuration` method, which is convenient to use. For example, the data corresponding to `BleSleepQuality` can be directly obtained by this method.

### (8) Is it possible to set the automatic detection interval for blood pressure?
No, the firmware does not support the automatic interval setting for blood pressure function at this phase. If the device supports it, the App can add this function.

### (9) Can it be detected currently that the watch is removed from the wrist?
No, our device does not support this function at this stage. If the device supports it, the App can add the corresponding function.

### (10) How to unbind the App and the device?
After running the SDK Demo and binding the device, click 0x03_CONNECT -> 0x0301_IDENTITY -> 0x30_DELETE to release the binding and turn off the device.

For the specific code, please refer to the `BleKeyFlagPage._onItemClick` method.

`BleConnector.getInstance.sendData(BleKey.IDENTITY, BleKeyFlag.DELETE)` is a command to unbind the device, which is applicable to some devices.

`BleConnector.getInstance.unbind()` is a mandatory command to unbind device, which is applicable to most situations and is more efficient.

### (11) How to check the battery level of the device?
The specific command key is `BleKey.POWER`

After running the SDK Demo and binding the device, click 0x02_SET -> 0x0203_POWER -> 0x10_READ to read the current power of the device.

The specific code is: `BleConnector.getInstance.sendData(BleKey.POWER, BleKeyFlag.READ)`

### (12) Whether the device can actively return the steps, heart rate, body temperature data
Sorry, the device currently does not support actively returning these data, and the App needs to actively read it

### (13) How to modify the unit displayed on the device (km, mile; Celsius, Fahrenheit)
Use the command `USER_PROFILE(0x0206)`

This command sends the data type `BleUserProfile`, where the `mUnit` parameter represents whether to use the metric system (km, degrees Celsius) or the imperial system (miles, degrees Fahrenheit)

For details, please refer to the usage example of `BleKey.USER_PROFILE` in the `BleKeyFlagPage` class of the SDK

### (14) How to obtain exercise data?

#### MTK, Goodix Platform
reference class `BleWorkout`

Use the command `WORKOUT(0x0506)` to obtain summary exercise data

Each piece of data is an exercise record

#### Other platforms

Reference class `BleActivity`

Sort by time, loop through all the synchronized `Activity` data, use the `mMode` parameter to distinguish different sports modes; use the `mState` parameter to determine the different states in the sports mode


#### Note
All platforms, during the exercise mode, will also generate heart rate, altitude, positioning and other data. You can use the start time and end time of the exercise to find the required data in the relevant data set.
The data content can refer to the class: `BleHeartRate` / `BleLocation`

### (15) How to use gesture wake-up function?
By command `BleKey.GESTURE_WAKE`, you can turn on and turn off the function of raising your hand to brighten the screen.
For details, please refer to the usage example of `BleKey.GESTURE_WAKE` in the `KeyFlagListActivity` class of the SDK

If you confirm that the setting is turned on, the device cannot respond effectively. First, it is recommended that you try to test from multiple angles for verification. If it is still invalid, please provide us with the device model and we will conduct further inspections.

### (16) How to calculate calories and distance data?
The SDK does not provide a specific calculation method. When the user information is set to the device using the `BleKey.USER_PROFILE` command, the calorie data and distance data will be directly obtained when reading the `Activity` data from the device.
 
The calculation method of distance is:
```
distance(km) = 45 * height(cm) * step / 10000 / 1000f
```
The calorie calculation method is:
```
Metric:
    kcal = 55 * weight (kg) * step / 10/10000
Imperial
    kcal = 46 * weight (kg) * step / 10/10000
```

### (17) What should I do if I send a READ command but do not receive a Callback?
If the device does not respond when the `READ` command is sent under the normal Bluetooth link state, it means that the device has not implemented the READ command operation of the command.

### (18) If the device is upgraded or is completely powered off, will it affect data storage?
Equipment upgrades or power exhaustion will not affect data storage.

These data include motion data generated during the operation of the device or instruction setting data issued by the App, such as user information.

### （19）Upgrade Instructions
Generally, there are three files, which are firmware package, UI package and font package. If multiple languages are supported, there are also language packs. The filename contains version information.

Firmware package: In most cases, only the firmware package can be used, and the ota sdk provided by the chip platform can be used.

```
//Get firmware version (format x.x.x)
BleConnector.sendData(BleKey.FIRMWARE_VERSION, BleKeyFlag.READ)

//Fired when the device returns a firmware version.
void onReadFirmwareVersion(String version) {}

//Start OTA
BleConnector.getInstance.startOTA(file)

//Progress
void onOTAProgress(double progress, int otaStatus, String error) {}
```

UI package: Only the UI package needs to be updated or the device interface display is abnormal.

```
//Get UI version (format x.x.x)
BleConnector.getInstance.sendData(BleKey.UI_PACK_VERSION, BleKeyFlag.READ)

//Fired when the device returns a firmware version.
void onReadUiPackVersion(String version) {}

//Send UI package
BleConnector.getInstance.sendStream(BleKey.UI_FILE, bytes)

//Progress
void onStreamProgress(bool status, int errorCode, int total, int completed)
```

Font package: Only when the device font display is abnormal, it needs to be updated, and it can be sent directly.

```
//Send font package
BleConnector.getInstance.sendStream(BleKey.FONT_FILE, bytes)

//Progress
void onStreamProgress(bool status, int errorCode, int total, int completed)
```

Language pack: The device supports multiple languages and needs to be updated when switching.

```
//Get language package version (format x.x.x)
BleConnector.getInstance.sendData(BleKey.LANGUAGE_PACK_VERSION, BleKeyFlag.READ)

//Triggered when the device returns a language package version
void onReadLanguagePackVersion(BleLanguagePackVersion version) {}

//send language package
BleConnector.getInstance.sendStream(BleKey.LANGUAGE_FILE, bytes)

//Progress
void onStreamProgress(bool status, int errorCode, int total, int completed)

//Set watch language
BleConnector.getInstance.sendInt8(BleKey.LANGUAGE, BleKeyFlag.UPDATE, languageCode)
```