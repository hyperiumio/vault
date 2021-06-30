#if DEBUG
import SwiftUI

struct ConfidentialTextPreview: PreviewProvider {
    
    static var previews: some View {
        ConfidentialText("foo", isVisible: true)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: false)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: true)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: false)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
