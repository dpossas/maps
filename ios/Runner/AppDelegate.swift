import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyC-TGOeme5ZgPoBge2r-bq3tlXhOBvNJxY")
    //GMSServices.provideAPIKey(String(ProcessInfo.processInfo.environment["GMAPS_API_KEY"] ?? ""))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
