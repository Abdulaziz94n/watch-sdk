import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_device.dart';

abstract class BleScanCallback {
  void onBluetoothDisabled() {}

  void onScan(bool scan) {}

  void onDeviceFound(BleDevice device) {}
}
