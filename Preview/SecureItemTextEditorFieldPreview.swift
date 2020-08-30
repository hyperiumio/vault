#if DEBUG
import SwiftUI

struct SecureItemTextEditorFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        SecureItemTextEditorField("Title", text: $text, isEditable: $isEditable)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
