import SwiftUI
import Combine

struct CustomTextField: View {
    @Binding var value: String
    var hintText: String
    var focused: FocusState<Bool>.Binding
    var height: CGFloat = 48
    
    func limitText(_ upper: Int) {
            if value.count > upper {
                value = String(value.prefix(upper))
            }
        }
    
    var body: some View {
        TextField(
            "****",
            text: $value
        )
            .focused(focused)
            .onReceive(Just(value)) { _ in limitText(4) }
            .multilineTextAlignment(.center)
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 16
                )
            )
            .accentColor(.black)
//            .placeholder(when: value.isEmpty) {
//                Text(hintText)
//                    .foregroundColor(textAdditional)
//            }
            .frame(
                width: UIScreen.main.bounds.width - 114,
                height: 56,
                alignment: .center
            )
            .padding(EdgeInsets(
                top: 0,
                leading: 20,
                bottom: 0,
                trailing: 20
            ))
    }
}

