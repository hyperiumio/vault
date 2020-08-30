import SwiftUI

struct SecureItemTextEditorField: View {
    
    let title: String
    let text: Binding<String>
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemField(title) {
            TextEditor(text: text)
                .disabled(!isEditable.wrappedValue)
        }
    }
    
    init(_ title: String, text: Binding<String>, isEditable: Binding<Bool>) {
        self.title = title
        self.text = text
        self.isEditable = isEditable
    }
    
}
