import SwiftUI

struct SecureItemTextField: View {
    
    private let title: String
    private let text: Binding<String>
    private let isEditable: Binding<Bool>
    
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
