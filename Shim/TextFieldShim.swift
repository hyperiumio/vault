import SwiftUI

#if os(iOS)
struct TextFieldShim: UIViewRepresentable {
    
    let title: String
    let text: Binding<String>
    let textStyle: UIFont.TextStyle
    let alignment: NSTextAlignment
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldShim>) -> UITextField {
        let action = #selector(Coordinator.textFieldDidChange)
        let textField = UITextField()
        textField.placeholder = title
        textField.font = UIFont.preferredFont(forTextStyle: textStyle)
        textField.textAlignment = alignment
        textField.addTarget(context.coordinator, action:action, for: .editingChanged)
        
        return textField
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldShim>) {
        uiView.text = text.wrappedValue
        
        if !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
}

extension TextFieldShim {
    
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
#endif

#if os(macOS)
struct TextFieldShim: NSViewRepresentable {
    
    let title: String
    let text: Binding<String>
    let isSecure: Bool
    let textStyle: NSFont.TextStyle
    let alignment: NSTextAlignment
    let action: () -> Void
    
    func makeNSView(context: Context) -> NSTextField {
        let attributes = [
            NSAttributedString.Key.foregroundColor: NSColor.secondaryLabelColor,
            NSAttributedString.Key.font: NSFont.preferredFont(forTextStyle: textStyle)
        ]
        
        let textField = isSecure ? NSSecureTextField() : NSTextField()
        textField.font = NSFont.preferredFont(forTextStyle: textStyle)
        textField.textColor = .labelColor
        (textField.cell as? NSTextFieldCell)?.placeholderAttributedString = NSAttributedString(string: "\(title)", attributes: attributes)
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.alignment = alignment
        textField.lineBreakMode = .byTruncatingMiddle
        textField.target = context.coordinator
        textField.action = #selector(Coordinator.doneButtonPressed)
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateNSView(_ textField: NSTextField, context: Context) {
        textField.stringValue = text.wrappedValue
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: text, action: action)
    }
    
}

extension TextFieldShim {
    
    class Coordinator: NSObject {
        
        let text: Binding<String>
        let action: () -> Void
        
        init(text: Binding<String>, action: @escaping () -> Void) {
            self.text = text
            self.action = action
        }
        
        @objc func doneButtonPressed() {
            action()
        }
        
    }
    
}

extension TextFieldShim.Coordinator: NSTextFieldDelegate {
    
    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as! NSTextField
        text.wrappedValue = textField.stringValue
    }
    
}
#endif
