import Flutter
import UIKit

public class SwiftSmaCodingDevFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "coding_dev_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftSmaCodingDevFlutterSdkPlugin();
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
