#if DEBUG
import SwiftUI

struct SecureItemKeyValueFieldPreview: PreviewProvider {
    
    @State static var keyText = ""
    @State static var valueText = ""
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            SecureItemKeyValueField(keyTitle: "Key", keyText: $keyText, valueTitle: "Value", valueText: $valueText, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            SecureItemKeyValueField(keyTitle: "Key", keyText: $keyText, valueTitle: "Value", valueText: $valueText, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
