import SwiftUI

struct SecureItemTextField: View {
    
    let title: String
    let text: Binding<String>
    
    @Binding var isEditable: Bool
    
    var body: some View {
        SecureItemField(title) {
            TextField(title, text: text)
                .disabled(!isEditable)
        }
    }
}
