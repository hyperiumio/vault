import SwiftUI

struct EditSecureItemTextField: View {
    
    private let title: String
    private let placeholder: String
    private let text: Binding<String>
    private let formatter: Formatter?
    
    init(_ title: String, placeholder: String, text: Binding<String>, formatter: Formatter? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.formatter = formatter
    }
    
    private var textBinding: Binding<String> {
        if let formatter = formatter {
            return Binding {
                formatter.string(for: text.wrappedValue) ?? text.wrappedValue
            } set: { value in
                var objectValue = nil as AnyObject?
                let success = formatter.getObjectValue(&objectValue, for: value, errorDescription: nil)
                if success, let value = objectValue as? String {
                    text.wrappedValue = value
                } else {
                    text.wrappedValue = value
                }
            }
        } else {
            return Binding {
                text.wrappedValue
            } set: { value in
                text.wrappedValue = value
            }
        }
    }
    
    #if os(iOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                TextField(placeholder, text: textBinding)
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                TextField(placeholder, text: textBinding)
            }
            .disableAutocorrection(true)
        }
    }
    #endif
    
}

#if DEBUG
struct EditSecureItemTextFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            List {
                EditSecureItemTextField("foo", placeholder: "bar", text: $text)
            }
            .preferredColorScheme(.light)
            
            List {
                EditSecureItemTextField("foo", placeholder: "bar", text: $text)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
