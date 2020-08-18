import SwiftUI

struct SecureItemKeyValueField: View {
    
    let keyTitle: String
    @Binding var keyText: String
    
    let valueTitle: String
    @Binding var valueText: String
    
    @Binding var isEditable: Bool
    
    var body: some View {
        SecureItemField(keyTitle, text: $keyText, isEditable: $isEditable) {
            TextField(valueTitle, text: $valueText)
                .disabled(!isEditable)
        }
    }
    
}
