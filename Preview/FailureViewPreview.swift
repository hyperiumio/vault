#if DEBUG
import SwiftUI

struct FailureViewPreview: PreviewProvider {
    
    static var previews: some View {
        FailureView("foo") {}
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FailureView("foo") {}
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
