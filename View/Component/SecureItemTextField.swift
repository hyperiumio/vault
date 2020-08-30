import SwiftUI

struct SecureItemTextField: View {
    
    let title: String
    let text: Binding<String>
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemField(title) {
            TextField(title, text: text)
                .disabled(!isEditable.wrappedValue)
        }
    }
    
    init(_ title: String, text: Binding<String>, isEditable: Binding<Bool>) {
        self.title = title
        self.text = text
        self.isEditable = isEditable
    }
    
}

#if DEBUG
struct SecureItemTextFieldPreviews: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        SecureItemTextField("Title", text: $text, isEditable: $isEditable)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
