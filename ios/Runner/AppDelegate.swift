import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      weak var registrar = self.registrar(forPlugin: "plugin-name")
      let factory = FLNativeViewFactory(messenger: registrar!.messenger())
      self.registrar(forPlugin: "<plugin-name>")?.register(factory, withId: "MySwiftUIView")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

