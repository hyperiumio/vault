#if DEBUG
import SwiftUI

struct SecureItemTextEditorFieldPreview: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        Group {
            SecureItemTextEditorField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            SecureItemTextEditorField("Title", text: $text, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
