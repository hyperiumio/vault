#if DEBUG
import SwiftUI

struct SecureItemTextFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        Group {
            SecureItemTextField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            SecureItemTextField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
