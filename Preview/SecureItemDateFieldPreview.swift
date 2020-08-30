#if DEBUG
import SwiftUI

struct SecureItemDateFieldPreview: PreviewProvider {
    
    @State static var date = Date()
    @State static var isEditable = true
    
    static var previews: some View {
        SecureItemDateField("Title", date: $date, isEditable: $isEditable)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
