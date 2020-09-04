#if DEBUG
import SwiftUI

struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            UnlockField("Password", text: $text) {}
                .preferredColorScheme(.light)
            
            UnlockField("Password", text: $text) {}
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
