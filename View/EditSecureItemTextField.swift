import SwiftUI

struct EditItemTextField: View {
    
    private let title: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let text: Binding<String>
    private let formatter: Formatter?
    
    init(_ title: LocalizedStringKey, placeholder: LocalizedStringKey, text: Binding<String>, formatter: Formatter? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.formatter = formatter
    }
    
    var body: some View {
        SecureItemView {
            ItemField(title) {
                if let formatter = formatter {
                    TextField(placeholder, value: text, formatter: formatter)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
    }
    
}

#if DEBUG
struct EditItemTextFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        List {
            EditItemTextField("foo", placeholder: "bar", text: $text)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
