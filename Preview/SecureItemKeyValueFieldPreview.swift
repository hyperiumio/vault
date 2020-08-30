#if DEBUG
import SwiftUI

struct SecureItemKeyValueFieldPreview: PreviewProvider {
    
    @State static var keyText = ""
    @State static var valueText = ""
    @State static var isEditable = true
    
    static var previews: some View {
        SecureItemKeyValueField(keyTitle: "Key", keyText: $keyText, valueTitle: "Value", valueText: $valueText, isEditable: $isEditable)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
