#if DEBUG
import SwiftUI

struct DateFooterPreview: PreviewProvider {
    
    static var previews: some View {
        DateFooter(created: .distantPast, modified: .distantFuture)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        DateFooter(created: .distantPast, modified: .distantFuture)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
