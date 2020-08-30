#if DEBUG
import SwiftUI

struct SecureItemFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            SecureItemField("Title") {
                Text("Field")
            }
            
            SecureItemField("Title", text: $text, isEditable: $isEditable) {
                Text("Field")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        
    }
    
}
#endif
