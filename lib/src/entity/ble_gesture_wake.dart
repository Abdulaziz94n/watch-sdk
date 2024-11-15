import '../../sma_coding_dev_flutter_sdk.dart';
import 'ble_base.dart';

class BleGestureWake extends BleBase<BleGestureWake> {
  BleTimeRange mBleTimeRange = BleTimeRange(0, 0, 0, 0, 0);

  BleGestureWake();

  @override
  String toString() {
    return "BleGestureWake(mBleTimeRange1=$mBleTimeRange)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["mBleTimeRange"] = mBleTimeRange.toJson();
    return map;
  }

  factory BleGestureWake.fromJson(Map map) {
    BleGestureWake gestureWake = BleGestureWake();
    gestureWake.mBleTimeRange = BleTimeRange.fromJson(map["mBleTimeRange"]);
    return gestureWake;
  }
}
