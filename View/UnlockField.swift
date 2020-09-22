import SwiftUI

struct UnlockField: View {
    
    private let title: String
    private let text: Binding<String>
    private let action: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            NativeTextField(title: title, text: text, action: action)
                .frame(height: 44)
                .padding(.horizontal, 20)
                .background(Color.textFieldBackground)
            
            Button(action: action) {
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
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        
    }
    
    init(_ title: String, text: Binding<String>, action: @escaping () -> Void) {
        self.title = title
        self.text = text
        self.action = action
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

#if canImport(AppKit)
import AppKit

private struct NativeTextField: NSViewRepresentable {
    
    let title: String
    let text: Binding<String>
    let action: () -> Void
    
    func makeNSView(context: Context) -> NSSecureTextField {
        let textField = NSSecureTextField()
        textField.font = .systemFont(ofSize: 20)
        textField.isBezeled = false
        textField.focusRingType = .none
        textField.placeholderString = title
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

extension NativeTextFieldCoordinator {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text.wrappedValue = textField.text ?? ""
    }
    
}
#endif
