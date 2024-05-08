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
            hintText,
            text: $value,
            axis: .horizontal
        )
            .focused(focused)
            .onReceive(Just(value)) { _ in limitText(4) }
            .font(
                .custom(
                    "OpenSans-Regular",
                    size: 16
                )
            )
            .foregroundStyle(Color(red: 0.149, green: 0.153, blue: 0.196))
            .accentColor(.black)
//            .placeholder(when: value.isEmpty) {
//                Text(hintText)
//                    .foregroundColor(textAdditional)
//            }
            .frame(height: 56, alignment: .center)
            .padding(EdgeInsets(
                top: 0,
                leading: 20,
                bottom: 0,
                trailing: 20
            ))
            .background(Color(red: 0.58, green: 0.631, blue: 0.698))
            .cornerRadius(8)
    }
}

