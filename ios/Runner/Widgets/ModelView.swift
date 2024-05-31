import SwiftUI

struct ModelView: View {
    @EnvironmentObject private var placementSettings: PlacementSettings
    @State private var isModelAdded: Bool = false
    
    var body: some View {
        VStack {
            if self.placementSettings.arView != nil {
                if self.placementSettings.arView!.scene.anchors.isEmpty {
                    Spacer()
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
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isModelAdded.toggle()
            }
        }
    }
}
