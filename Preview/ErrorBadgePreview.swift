#if DEBUG
import SwiftUI

struct ErrorMessagePreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            ErrorBadge("Invalid password")
                .preferredColorScheme(.light)
            
            ErrorBadge("Invalid password")
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
