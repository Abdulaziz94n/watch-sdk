import 'package:flutter/foundation.dart';

class BleLog {
  static String TAG = 'SMA';

  static bool isDebug = kReleaseMode ? false : true;

  static void d(Object object, {String? tag}) {
    if (isDebug) {
      print("D/${(tag == null || tag.isEmpty) ? TAG : tag}: $object");
    }
  }

  static void v(Object object, {String? tag}) {
    print("V/${(tag == null || tag.isEmpty) ? TAG : tag}: $object");
  }

  static void e(Object object, {String? tag}) {
    print("E/${(tag == null || tag.isEmpty) ? TAG : tag}: $object");
  }
}
