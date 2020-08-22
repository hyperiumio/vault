import SwiftUI

struct UnlockField: View {
    
    let title: String
    let text: Binding<String>
    let unlock: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            NativeTextField(name: title, text: text, action: unlock)
                .frame(height: 44)
                .padding(texfieldInsets)
                .background(Color.textFieldBackground)
            
            Button(action: unlock) {
                Image.lock
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(Color.white)
            }
            .frame(width: 44, height: 44)
            .background(Color.accentColor)
            .buttonStyle(PlainButtonStyle())
        }
        .clipShape(textfieldClipShape)
        
    }
    
    var textfieldClipShape: some Shape {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
    
    var texfieldInsets: EdgeInsets {
        EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
}

#if canImport(AppKit)
import AppKit

private struct NativeTextField: NSViewRepresentable {
    
    let name: String
    let text: Binding<String>
    let action: () -> Void
    
    func makeNSView(context: Context) -> NSSecureTextField {
        let textField = NSSecureTextField()
        textField.font = .systemFont(ofSize: 20)
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.placeholderString = name
        textField.target = context.coordinator
        textField.action = #selector(Coordinator.doneButtonPressed)
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateNSView(_ textField: NSSecureTextField, context: Context) {
        textField.stringValue = text.wrappedValue
    }
    
    func makeCoordinator() -> NativeTextFieldCoordinator {
        return NativeTextFieldCoordinator(text: text, action: action)
    }
    
}

private class NativeTextFieldCoordinator: NSObject {
    
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

extension NativeTextFieldCoordinator: NSTextFieldDelegate {
    
    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as! NSTextField
        text.wrappedValue = textField.stringValue
    }
    
}
#endif

#if canImport(UIKit)
import UIKit

private struct NativeTextField: UIViewRepresentable {
    
    let title: String
    let text: Binding<String>
    let action: () -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.placeholder = title
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.doneButtonPressed), for: .editingDidEndOnExit)
        
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        textField.text = text.wrappedValue
    }
    
    func makeCoordinator() -> NativeTextFieldCoordinator {
        return NativeTextFieldCoordinator(text: text, action: action)
    }
    
}

private class NativeTextFieldCoordinator: NSObject {
    
    let text: Binding<String>
    let action: () -> Void
    
    init(text: Binding<String>, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text.wrappedValue = textField.text ?? ""
    }
    
    @objc func doneButtonPressed() {
        action()
    }
    
}
#endif

#if DEBUG
struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        UnlockField(title: "Password", text: $text, unlock: {})
            .preferredColorScheme(.dark)
            .padding()
    }
    
}
#endif
