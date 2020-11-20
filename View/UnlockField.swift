import SwiftUI

struct UnlockField: View {
    
    private let title: String
    private let text: Binding<String>
    private let action: () -> Void
    
    init(_ title: String, text: Binding<String>, action: @escaping () -> Void) {
        self.title = title
        self.text = text
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            SecureField(title, text: text)
                .font(.system(size: 20))
                .disableAutocorrection(true)
                .frame(height: 44)
                .padding(.horizontal, 20)
                .background(Color.textFieldBackground)
            
            Button(action: action) {
                Image.lock
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
            .background(Color.accentColor)
            .buttonStyle(PlainButtonStyle())
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: text, action: action)
    }
    
}

private extension NativeTextField {
    
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

#if DEBUG
struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            UnlockField("foo", text: $text) {}
                .preferredColorScheme(.light)
            
            UnlockField("foo", text: $text) {}
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
