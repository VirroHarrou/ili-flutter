import SwiftUI

struct ModelView: View {
    @EnvironmentObject private var placementSettings: PlacementSettings
    @State private var isModelAdded: Bool = false
    
    var body: some View {
        VStack {
            if !isModelAdded {
                Spacer()
                    .frame(height: 50)
                Text(
                    "Нажмите на горизонтальную поверхность"
                )
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
            }
            Spacer()
            Text(
                "Вращайте модель двумя пальцами"
            )
            .font(.system(
                size: 16,
                weight: .semibold
            ))
            .foregroundStyle(.white)
            Spacer()
                .frame(height: 16)
            Text(
                "Перемещайте модель зажатием"
            )
            .font(.system(
                size: 16,
                weight: .semibold
            ))
            .foregroundStyle(.white)
            Spacer()
                .frame(height: 36)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isModelAdded.toggle()
            }
        }
    }
}
