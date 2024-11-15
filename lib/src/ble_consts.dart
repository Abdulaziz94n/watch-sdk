const int BLE_OK = 0;
const int BLE_ERROR = 1;
const int ID_ALL = 0xff;

/// 1970/1/1 00:00:00距离2000/1/1 00:00:00的秒数
const int DATA_EPOCH = 946684800;

class BleState {
  ///设备已断开
  static const int DISCONNECTED = -1;

  ///设备已连接，但还未执行发现服务，通知矢能，设置MTU，还不能收发指令
  static const int CONNECTED = 0;

  ///设备已就绪，已执行发现服务，通知矢能，设置MTU，可以正常收发发送指令
  static const int READY = 1;
}

class CameraState {
  static const int EXIT = 0;

  static const int ENTER = 1;

  static const int CAPTURE = 2;
}

class SyncState {
  /// 同步过程中，连接断开
  static const int DISCONNECTED = -2;

  /// 同步超时
  static const int TIMEOUT = -1;

  /// 同步完成
  static const int COMPLETED = 0;

  /// 同步中
  static const int SYNCING = 1;
}

class WorkoutState {
  static const int START = 1;
  static const int ONGOING = 2;
  static const int PAUSE = 3;
  static const int END = 4;
}

class OTAStatus {
  ///ota前有些预操作，如先扫描，再连接，连接成功才开始升级
  static const int OTA_PREPARE = 1;

  ///ota前准备工作失败
  static const int OTA_PREPARE_FAILED = 2;

  ///ota开始
  static const int OTA_START = 3;

  ///ota文件校验中, 杰里平台需要先校验文件后才开始升级
  static const int OTA_CHECKING = 4;

  ///ota升级中
  static const int OTA_UPGRADEING = 5;

  ///ota完成
  static const int OTA_DONE = 6;

  ///ota失败
  static const int OTA_FAILED = 7;

  ///未知
  static const int UNKNOWN = -1;
}

class PowerSaveModeState {
  static const int CLOSE = 0; //关闭指令
  static const int OPEN = 1; //开启指令
}

///二维码类型
class QrcodeType {
  ///核酸码
  static const int NUCLEIC_ACID_CODE = 0;

  ///收款码
  static const int RECEIPT_CODE = 1;

  ///我的名片[MyCardType]
  static const int MY_CARD_CODE = 2;
}

///我的名片类型
class MyCardType {
  static const int WECHAT = 2;

  static const int QQ = 3;

  static const int SKYPE = 4;

  static const int FACEBOOK = 5;

  static const int TWITTER = 6;

  static const int WHATSAPP = 7;

  static const int LINE = 8;

  static const int INSTAGRAM = 9;
}