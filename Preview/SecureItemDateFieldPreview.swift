#if DEBUG
import SwiftUI

struct SecureItemDateFieldPreview: PreviewProvider {
    
    @State static var date = Date()
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            SecureItemDateField("Title", date: $date, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            SecureItemDateField("Title", date: $date, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
