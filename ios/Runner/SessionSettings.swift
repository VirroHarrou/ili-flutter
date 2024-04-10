import SwiftUI

// Managing Model Data in Your App: https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app
// How to use @EnvironmentObject to share data between views: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views

class SessionSettings: ObservableObject {
    @Published var isMultiuserEnabled: Bool = false
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
}
