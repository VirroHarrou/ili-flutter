import SwiftUI

struct CustomSnackBar: View {
    var text: String
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 100)
            HStack {
                Spacer()
                    .frame(width: 12)
                Image(systemName: "checkmark")
                    .foregroundColor(Color(
                        red: 0.149,
                        green: 0.153,
                        blue: 0.196
                    ))
                Spacer()
                    .frame(width: 2)
                Text(text)
                .font(.system(
                    size: 14,
                    weight: .medium
                ))
                .foregroundStyle(Color(
                    red: 0.149,
                    green: 0.153,
                    blue: 0.196
                ))
                Spacer()
                Spacer()
                    .frame(width: 26)
            }
            .padding(
                [.vertical],
                13
            )
            .background(.white.opacity(0.4))
            .cornerRadius(13)
            Spacer()
                .frame(width: 20)
        }
    }
}
