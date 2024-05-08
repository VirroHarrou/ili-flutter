import SwiftUI

// Managing User Interface State: https://developer.apple.com/documentation/swiftui/managing-user-interface-state

struct ContentView1: View {
    var path: String
    
    var body: some View {
        ContentView(path: path)
            .environmentObject(SessionSettings())
            .environmentObject(PlacementSettings())
            .environmentObject(SceneManager())
            .environmentObject(ModelsViewModel())
            .environmentObject(ModelDeletionManager())
    }
}

struct ContentView: View {
    var path: String
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var sceneManager: SceneManager

    @State private var selectedControlMode: Int = 0
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false
    
    @State private var text: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ARViewContainer()
            
            if self.placementSettings.selectedModel == nil {
                PlacementView()
            }
            else {
                //DeletionView()
            }
            
//            if self.placementSettings.selectedModel != nil {
//                PlacementView()
//            } else if self.modelDeletionManager.entitySelectedForDeletion != nil {
//                DeletionView()
//            } else {
////                ControlView(selectedControlMode: $selectedControlMode, isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
//            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            // Fetch Data from Firebase Storage
            self.modelsViewModel.fetchData(path: path)
        }
    }
}
