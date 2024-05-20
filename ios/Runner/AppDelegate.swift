import UIKit
import SwiftUI
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName =  "com.hendrick.navigateChannel"
    private let navigateFunctionName = "flutterNavigate"
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      
    
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      GeneratedPluginRegistrant.register(with: self)
      
      let navigationController = DelegateViewController(rootViewController: controller)
      
      navigationController.isNavigationBarHidden = true
      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()
      
      let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
      
      methodChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          navigationController.result = result
          
          if call.method == self.navigateFunctionName {
              let swiftUIViewController = UIHostingController(
                rootView: ContentView1(
                    path: (call.arguments as! [String: Any])["path"] as! String,
                    id: (call.arguments as! [String: Any])["id"] as! String,
                    title: (call.arguments as! [String: Any])["title"] as! String,
                    description: (call.arguments as! [String: Any])["description"] as! String,
                    like: (call.arguments as! [String: Any])["like"] as! Bool,
                    navigationController: navigationController
                )
              )
              
              navigationController.pushViewController(swiftUIViewController, animated: true)
          }
      })
      
      return super.application(application, didFinishLaunchingWithOptions:launchOptions)
  }
}
