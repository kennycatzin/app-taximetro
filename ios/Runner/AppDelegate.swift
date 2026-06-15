import UIKit
import Flutter
import GoogleMaps


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.setMetalRendererEnabled(false)
    GMSServices.provideAPIKey("AIzaSyBM7I6iB-JsPxDCk6-TTSu4SF3NHVBHdPU")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
