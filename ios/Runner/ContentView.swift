import SwiftUI

struct ContentView1: View {
    var access_token: String
    
    weak var navigationController: UINavigationController?
    
    var body: some View {
        ContentView(
            access_token: access_token,
            navigationController: navigationController
        )
            .environmentObject(SessionSettings())
            .environmentObject(PlacementSettings())
            .environmentObject(ModelDeletionManager())
    }
}

struct ContentView: View {
    var access_token: String
    
    weak var navigationController: UINavigationController?
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager

    @State private var selectedControlMode: Int = 0
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false
    
    @State private var text: String = ""
    @FocusState private var focused: Bool
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            
            ARViewContainer(path: access_token)
            
            VStack {
                Spacer()
                    .frame(height: 30)
                HStack {
                    Spacer()
                        .frame(width: 30)
                    Button(action: {
                        navigationController?.popViewController(animated: true)
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.4))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    Spacer()
                }
                Spacer()

                
//                if self.placementSettings.customType == .place {
//                    PlacementView()
//                }
//                else if self.placementSettings.customType == .scan {
//                    ScanView(isFocused: _isFocused)
//                }
//                else {
                    ModelView()
//                }
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
//        .onAppear() {
//            self.placementSettings.fetchData(path: access_token)
//            //self.placementSettings.access_token = access_token
//        }
        .sheet(isPresented: $placementSettings.isPresented) {
            CustomBottomSheet()
                .presentationDetents([.medium])
        }
        .onTapGesture {
            isFocused = false
        }
    }
}
