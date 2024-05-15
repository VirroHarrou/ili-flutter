import SwiftUI

struct ModelView: View {
    
    var body: some View {
        VStack {
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
    }
}
