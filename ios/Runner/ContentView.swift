import SwiftUI
import UniformTypeIdentifiers

struct ContentView1: View {
    var path: String
    var id: String
    var title: String
    var description: String
    var like: Bool
    
    weak var navigationController: UINavigationController?
    
    var body: some View {
        ContentView(
            path: path,
            id: id,
            title: title,
            description: description,
            like: like,
            navigationController: navigationController
        )
            .environmentObject(SessionSettings())
            .environmentObject(PlacementSettings())
            .environmentObject(ModelDeletionManager())
    }
}

struct ContentView: View {
    var path: String
    var id: String
    var title: String
    var description: String
    var like: Bool
    
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
    
    @State private var isModelAdded: Bool = false
    
    @State private var scale: Float = 1.0
    
    @State private var screenShot: Image?
    
    @State private var isFavorite: Bool = false
    @State private var isShowFavorite: Bool = false
    
    @State private var isShowCopy: Bool = false
    
    @State private var isSheet: Bool = false
    
    @State private var isShowPhoto: Bool = false
    
    @State private var isShowButtons: Bool = true {
        didSet {
            if !isShowButtons {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.screenShot = self.takeScreenshot()
                }
            }
        }
    }
    
    func takeScreenshot() -> Image {
            let view = UIApplication.shared.windows.first?.rootViewController?.view

            let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
            let image = renderer.image { ctx in
                view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }

            return Image(uiImage: image)
        }
    
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                
                ARViewContainer(path: path)
                    .opacity(screenShot == nil ? 1 : 0.3)
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    ZStack {
                        HStack {
                            Spacer()
                                .frame(width: 30)
                            if self.isShowButtons {
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
                            }
                            Spacer()
                        }
                        
                        CustomSnackBar(text: "В избранном")
                            .animation(.easeInOut(duration: 0.2))
                            .offset(
                                y: isShowFavorite ? 0 : -200
                            )
                        
                        CustomSnackBar(text: "Код модели скопирован в буфер")
                            .animation(.easeInOut(duration: 0.2))
                            .offset(
                                y: isShowCopy ? 0 : -200
                            )
                        
                        CustomSnackBar(text: "Фото сохранено")
                            .animation(.easeInOut(duration: 0.2))
                            .offset(
                                y: isShowPhoto ? 0 : -200
                            )
                    }
                    Spacer()
                    if !self.isShowButtons {
                        
                    }
                    else if !isModelAdded && (
                        self.placementSettings.arView != nil &&
                        self.placementSettings.arView!.scene.anchors.isEmpty
                    ) {
                        Text(
                            "Нажмите на горизонтальную поверхность"
                        )
                        .multilineTextAlignment(.center)
                        .font(.system(
                            size: 20,
                            weight: .semibold
                        ))
                        .foregroundStyle(.white)
                        Spacer()
                            .frame(height: 16)
                        Image("arrow")
                        Spacer()
                            .frame(height: 14)
                        Image("icon-park-outline_trapezoid")
                        Spacer()
                    }
                    else {
                        HStack {
                            VStack {
                                Button (action: {
                                    self.placementSettings.isTap = true
                                    if self.scale >= 1 {
                                        self.scale += 1
                                    }
                                    else {
                                        self.scale += 0.1
                                    }
                                    self.placementSettings.arView?.scene.anchors.first?.scale = [
                                        self.scale,
                                        self.scale,
                                        self.scale
                                    ]
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.placementSettings.isTap = false
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(.clear)
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                            .frame(width: 48, height: 48)
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                    }
                                        }
                                Spacer()
                                    .frame(height: 13)
                                Text(String(
                                    format: "%.1fx",
                                    self.scale
                                ))
                                .font(.system(
                                    size: 16,
                                    weight: .semibold
                                ))
                                .foregroundStyle(.white)
                                Spacer()
                                    .frame(height: 13)
                                Button (action: {
                                    if self.scale != 0.1 {
                                        self.placementSettings.isTap = true
                                        if self.scale > 1 {
                                            self.scale -= 1
                                        }
                                        else {
                                            self.scale -= 0.1
                                        }
                                        self.placementSettings.arView?.scene.anchors.first?.scale = [
                                            self.scale,
                                            self.scale,
                                            self.scale
                                        ]
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.placementSettings.isTap = false
                                        }
                                    }
                                }) {
                                    ZStack {
                                                Circle()
                                                    .fill(Color.clear)
                                                    .overlay(Circle().stroke(.white, lineWidth: 2))
                                                    .frame(width: 48, height: 48)
                                                
                                                Image(systemName: "minus")
                                                    .foregroundColor(.white)
                                                    .frame(width: 24, height: 24)
                                            }
                                }
                                Spacer()
                                    .frame(height: 44)
//                                Button(action: {
//                                    self.placementSettings.arView?.scene.anchors.first?.removeFromParent()
//                                }) {
//                                    Image("eos-icons_content-deleted")
//                                }
//                                Spacer()
//                                    .frame(height: 30)
                            }
                            Spacer()
                            Button (action: {
                                self.isShowButtons = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .overlay(Circle().stroke(.white, lineWidth: 1))
                                        .frame(width: 80, height: 80)
                                    Circle()
                                        .fill(.white)
                                        .overlay(Circle().stroke(.black, lineWidth: 1))
                                        .frame(width: 60, height: 60)
                                }
                            }
                            Spacer()
                            VStack {
//                                Button(action: {
//                                    if self.isFavorite {
//                                        self.isFavorite = false
//                                    }
//                                    else {
//                                        withAnimation {
//                                            if self.isShowCopy {
//                                                self.isShowCopy = false
//                                            }
//                                            if self.isShowPhoto {
//                                                self.isShowCopy = false
//                                            }
//                                            self.isFavorite = true
//                                            self.isShowFavorite = true
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                                self.isShowFavorite = false
//                                            }
//                                        }
//                                    }
//                                }) {
//                                    Image(systemName: self.isFavorite ? "heart.fill" : "heart")
//                                        .frame(
//                                            width: 32,
//                                            height: 32
//                                        )
//                                        .foregroundColor(.white)
//                                }
//                                Spacer()
//                                    .frame(height: 40)
//                                Button(action: {
//                                    UIPasteboard.general.setValue(
//                                        self.id,
//                                        forPasteboardType: UTType.plainText.identifier
//                                    )
//                                    withAnimation {
//                                        if self.isShowFavorite {
//                                            self.isShowFavorite = false
//                                        }
//                                        if self.isShowPhoto {
//                                            self.isShowPhoto = false
//                                        }
//                                        self.isShowCopy = true
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                            self.isShowCopy = false
//                                        }
//                                    }
//                                }) {
//                                    Image(systemName: "arrowshape.turn.up.right.fill")
//                                        .frame(
//                                            width: 32,
//                                            height: 32
//                                        )
//                                        .foregroundColor(.white)
//                                }
                                Spacer()
                                    .frame(height: 40)
                                Button(action: {
                                    self.isSheet = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(
                                            width: 32,
                                            height: 32
                                        )
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                    .frame(height: 30)
                            }
                        }
                        .padding(
                            [.horizontal],
                            20
                        )
                    }
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
                if screenShot != nil {
                    ZStack (alignment: .bottom) {
                        screenShot?
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.size.width - 40,
                                height: UIScreen.main.bounds.size.height - 246
                            )
                            .scaledToFit()
                            .cornerRadius(16)
                        HStack {
                            Button(
                                action: {
                                    self.isShowButtons = true
                                    self.screenShot = nil
                                }
                            ) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .foregroundStyle(Color(
                                            red: 0.149,
                                            green: 0.153,
                                            blue: 0.196
                                        ))
                                    Spacer()
                                        .frame(width: 8)
                                    Text(
                                        "Переснять"
                                    )
                                    .font(.system(
                                        size: 16,
                                        weight: .medium
                                    ))
                                    .foregroundStyle(Color(
                                        red: 0.149,
                                        green: 0.153,
                                        blue: 0.196
                                    ))
                                }
                            }
                            .padding(
                                [.vertical],
                                13
                            )
                            .padding(
                                [.horizontal],
                                23.5
                            )
                            .frame(
                                //width: 160,
                                height: 48
                            )
                            .background(Color(
                                red: 0.973,
                                green: 0.973,
                                blue: 0.973
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        Color(
                                            red: 0.149,
                                            green: 0.153,
                                            blue: 0.196
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .cornerRadius(24)
                            Spacer()
                                .frame(width: 14)
                            Button(
                                action: {
                                    guard let inputImage = self.screenShot?.asUIImage() else { return }

                                        let imageSaver = ImageSaver()
                                        imageSaver.writeToPhotoAlbum(image: inputImage)
                                    withAnimation {
                                        if self.isShowFavorite {
                                            self.isShowFavorite = false
                                        }
                                        if self.isShowCopy {
                                            self.isShowCopy = false
                                        }
                                        self.isShowPhoto = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            self.isShowPhoto = false
                                        }
                                    }
                                    self.isShowButtons = true
                                    self.screenShot = nil
                                }
                            ) {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                        .foregroundStyle(.white)
                                    Spacer()
                                        .frame(width: 8)
                                    Text(
                                        "Сохранить"
                                    )
                                    .font(.system(
                                        size: 16,
                                        weight: .medium
                                    ))
                                    .foregroundStyle(.white)
                                }
                            }
                            .padding(
                                [.vertical],
                                13
                            )
                            .padding(
                                [.horizontal],
                                23.5
                            )
                            .frame(
                                //width: 160,
                                height: 48
                            )
                            .background(Color(
                                red: 0.149,
                                green: 0.153,
                                blue: 0.196
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        Color(
                                            red: 0.149,
                                            green: 0.153,
                                            blue: 0.196
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .cornerRadius(24)
                        }
                        .padding(
                            [.vertical],
                            20
                        )
                    }
                    .padding(
                        [.all],
                        20
                    )
                    .frame(
                        width: UIScreen.main.bounds.size.width - 40,
                        height: UIScreen.main.bounds.size.height - 246
                    )
                }
                
    //            if self.placementSettings.selectedModel != nil {
    //                PlacementView()
    //            } else if self.modelDeletionManager.entitySelectedForDeletion != nil {
    //                DeletionView()
    //            } else {
    ////                ControlView(selectedControlMode: $selectedControlMode, isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
    //            }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.isFavorite = self.like
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isModelAdded.toggle()
            }
        }
//        .onAppear() {
//            self.placementSettings.fetchData(path: access_token)
//            //self.placementSettings.access_token = access_token
//        }
        .sheet(isPresented: $isSheet) {
            CustomBottomSheet(title: title, description: description)
                .presentationDetents([.medium])
        }
        .onTapGesture {
            isFocused = false
        }
    }
}
