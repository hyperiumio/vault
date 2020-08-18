import SwiftUI

struct SecureItemTextEditorField: View {
    
    let title: String
    
    @Binding var text: String
    @Binding var isEditable: Bool
    
    var body: some View {
        SecureItemField(title) {
            TextEditor(text: $text)
                .disabled(!isEditable)
        }
    }
    
}
