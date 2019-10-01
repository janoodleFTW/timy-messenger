import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

    UploadService.shared.configureFlutterHandler(flutterBinaryMessenger: window.rootViewController as! FlutterBinaryMessenger)
    PermissionService.shared.configureFlutterHandler(flutterBinaryMessenger: window.rootViewController as! FlutterBinaryMessenger)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
