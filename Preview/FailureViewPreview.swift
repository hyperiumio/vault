#if DEBUG
import SwiftUI

struct FailureViewPreview: PreviewProvider {
    
    static var previews: some View {
        FailureView("foo") {
            print("reload")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        FailureView("foo") {
            print("reload")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
