#if DEBUG
import SwiftUI

struct ErrorMessagePreview: PreviewProvider {
    
    static var previews: some View {
        ErrorBadge("Invalid password")
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
