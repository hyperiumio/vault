#if DEBUG
import SwiftUI

struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        UnlockField("Password", text: $text) {}
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
