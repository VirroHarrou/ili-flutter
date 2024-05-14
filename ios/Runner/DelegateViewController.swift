import Foundation
import Flutter

class DelegateViewController : UINavigationController {
    var result : FlutterResult?
    
    func popViewController(string: String) {
        result?(string)
    }
}
