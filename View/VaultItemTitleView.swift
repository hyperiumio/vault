import Localization
import SwiftUI

struct VaultItemTitleView: UIViewRepresentable {
    
    private let title: String
    private let text: Binding<String>

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    func makeUIView(context: UIViewRepresentableContext<VaultItemTitleView>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = title
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        
        return textField
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<VaultItemTitleView>) {
        uiView.text = text.wrappedValue
        
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

extension VaultItemTitleView {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        let text: Binding<String>
        var didBecomeFirstResponder = false

        init(_ text: Binding<String>) {
            self.text = text
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }

    }
    
}
