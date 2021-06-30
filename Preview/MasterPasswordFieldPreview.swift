#if DEBUG
import SwiftUI

struct MasterPasswordFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        MasterPasswordField("foo", text: $text) {}
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        MasterPasswordField("foo", text: $text) {}
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
