#if DEBUG
import SwiftUI

struct SecureItemFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            SecureItemField("Title", text: $text, isEditable: $isEditable) {
                Text("Field")
            }
            .preferredColorScheme(.light)
            
            SecureItemField("Title", text: $text, isEditable: $isEditable) {
                Text("Field")
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        
    }
    
}
#endif
