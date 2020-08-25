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

#if DEBUG
struct SecureItemKeyValueFieldPreviews: PreviewProvider {
    
    @State static var keyText = ""
    @State static var valueText = ""
    @State static var isEditable = true
    
    static var previews: some View {
        SecureItemKeyValueField(keyTitle: "Key", keyText: $keyText, valueTitle: "Value", valueText: $valueText, isEditable: $isEditable)
    }
    
}
#endif
