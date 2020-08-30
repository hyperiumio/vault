#if DEBUG
import SwiftUI

struct SecureItemSecureFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        SecureItemSecureField("Title", text: $text, isEditable: $isEditable)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
