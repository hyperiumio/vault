#if DEBUG
import SwiftUI

struct SecureItemSecureFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        Group {
            SecureItemSecureField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            SecureItemSecureField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
