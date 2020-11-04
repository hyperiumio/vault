import SwiftUI

#if os(iOS)
struct EditSecureItemTextField: View {
    
    private let title: String
    private let placeholder: String
    private let text: Binding<String>
    
    init(_ title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }
    
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                TextField(placeholder, text: text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
