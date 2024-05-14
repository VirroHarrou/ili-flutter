import SwiftUI

struct ScanView: View {
    @FocusState var isFocused: Bool
    @State private var value: String = ""
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    var body: some View {
        VStack {
            Spacer()
            if !isFocused {
                Text(
                    "Наведите камеру на QR-код"
                )
                .font(.system(
                    size: 16,
                    weight: .semibold
                ))
                .foregroundStyle(.white)
                Spacer()
            }
            Text(
                "Или введите код модели"
            )
            .font(.system(
                size: 16,
                weight: .semibold
            ))
            .foregroundStyle(.white)
            Spacer()
                .frame(height: 16)
            CustomTextField(
                value: $value,
                hintText: "",
                focused: $isFocused
            )
            .background(isFocused ? .white : Color(red: 0.58, green: 0.631, blue: 0.698).opacity(0.2))
            .foregroundStyle(.black)
            .cornerRadius(8)
            .onChange(of: value) {
                if value.count == 4 {
                    DispatchQueue.main.async {
                        self.placementSettings.isLoading = true
                        self.placementSettings.makeRequest(
                            id: value
                        ) { (result: Result<CustomModel, Error>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let customModel1):
                                    self.placementSettings.customModel = customModel1
                                    self.placementSettings.isLoading = false
                                    self.placementSettings.isPresented = true
                                case .failure(_):
                                    self.placementSettings.isLoading = false
                                    print("failure")
                                }
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                isFocused = true
            }
            Spacer()
            Text(
                "Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты."
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
//
//struct PinEntryView: View {
//        
//    var pinLimit: Int = 4
//    var isError: Bool = false
//    var canEdit: Bool = true
//    @Binding var pinCode: String
//
//    private var pins: [String] {
//        return pinCode.map { String($0) }
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                PinCodeTextField(limit: pinLimit, canEdit: canEdit, text: $pinCode)
//                    .border(Color.black, width: 1)
//                    .frame(height: 60)
//                    .padding()
//            }
//            .opacity(0)
//            
//            VStack {
//                HStack(spacing: 32) {
//                    ForEach(0 ..< pinLimit) { item in
//                        if item < pinCode.count { // Make sure we do not get an out of range error
//                            Text(pins[item])
//                                .font(.title)
//                                .bold()
//                                .foregroundColor(isError ? .red : .primary)
//                            
//                        } else {
//                            Circle()
//                                .stroke(Color.secondary, lineWidth: 4)
//                                .frame(width: 16, height: 16)
//                        }
//                    }
//                    .frame(width: 24, height: 32) // We give a constant frame to avoid any layout movements when the state changes.
//                }
//            }
//        }
//    }
//}
//
//struct PinEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StatefulPreviewWrapper("") {
//                PinEntryView(pinCode: $0)
//            }
//            .previewLayout(.sizeThatFits)
//            StatefulPreviewWrapper("12") {
//                PinEntryView(pinCode: $0)
//            }
//            .previewLayout(.sizeThatFits)
//            
//            StatefulPreviewWrapper("1333") {
//                PinEntryView(isError: true, pinCode: $0)
//            }
//            .previewLayout(.sizeThatFits)
//            
//            StatefulPreviewWrapper("12") {
//                PinEntryView(pinLimit: 6, pinCode: $0)
//            }
//            .previewLayout(.sizeThatFits)
//            
//            StatefulPreviewWrapper("12") {
//                PinEntryView(pinLimit: 6, pinCode: $0)
//            }
//            .background(Color.black)
//            .previewLayout(.sizeThatFits)
//            .colorScheme(.dark)
//        }
//    }
//}
//
///// A UITextField Representable that enables the PinField to become first responder.
//struct PinCodeTextField: UIViewRepresentable {
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//
//        var limit: Int
//        var canEdit: Bool
//        @Binding var text: String
//
//        init(limit: Int, canEdit: Bool, text: Binding<String>) {
//            self.limit = limit
//            self.canEdit = canEdit
//            self._text = text
//        }
//
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            DispatchQueue.main.async {
//                self.text = textField.text ?? ""
//            }
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if !canEdit {
//                return false
//            }
//            
//            let currentText = textField.text ?? ""
//
//            guard let stringRange = Range(range, in: currentText) else { return false }
//
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//            return updatedText.count <= limit
//        }
//    }
//
//    var limit: Int
//    var canEdit: Bool
//    @Binding var text: String
//
//    func makeUIView(context: UIViewRepresentableContext<PinCodeTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
//        textField.delegate = context.coordinator
//        textField.textAlignment = .center
//        textField.keyboardType = .decimalPad
//        return textField
//    }
//
//    func makeCoordinator() -> PinCodeTextField.Coordinator {
//        return Coordinator(limit: limit, canEdit: canEdit, text: $text)
//    }
//
//    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PinCodeTextField>) {
//        uiView.text = text
//        context.coordinator.canEdit = canEdit
//        uiView.becomeFirstResponder()
//    }
//}
//
///// A Utility view to view previews with a single Binding
//struct StatefulPreviewWrapper<Value, Content: View>: View {
//    
//    // MARK: - Properties
//    
//    var content: (Binding<Value>) -> Content
//    @State private var value: Value
//    
//    // MARK: - Initializer
//
//    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
//        self._value = State(wrappedValue: value)
//        self.content = content
//    }
//    
//    // MARK: - Body
//    
//    var body: some View {
//        content($value)
//    }
//}
