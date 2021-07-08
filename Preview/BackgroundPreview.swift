#if DEBUG
import SwiftUI

struct BackgroundPreview: PreviewProvider {
    
    static var previews: some View {
        Background()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        Background()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
