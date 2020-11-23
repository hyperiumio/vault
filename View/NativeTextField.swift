import SwiftUI

#if os(macOS)
struct NativeTextField: NSViewRepresentable {
    
    let title: String
    let text: Binding<String>
    let textStyle: NSFont.TextStyle
    let action: () -> Void
    
    func makeNSView(context: Context) -> NSSecureTextField {
        let textField = NSSecureTextField()
        textField.font = NSFont.preferredFont(forTextStyle: textStyle)
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.alignment = .center
        textField.lineBreakMode = .byTruncatingMiddle
        textField.placeholderString = title
        textField.target = context.coordinator
        textField.action = #selector(Coordinator.doneButtonPressed)
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateNSView(_ textField: NSSecureTextField, context: Context) {
        textField.stringValue = text.wrappedValue
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: text, action: action)
    }
    
}

extension NativeTextField {
    
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

extension NativeTextField.Coordinator: NSTextFieldDelegate {
    
    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as! NSTextField
        text.wrappedValue = textField.stringValue
    }
    
}
#endif
