import SwiftUI

struct SecureItemKeyValueField: View {
    
    let keyTitle: String
    let keyText: Binding<String>
    
    let valueTitle: String
    let valueText: Binding<String>
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemField(keyTitle, text: keyText, isEditable: isEditable) {
            TextField(valueTitle, text: valueText)
                .disabled(!isEditable.wrappedValue)
        }
    }
    
}
