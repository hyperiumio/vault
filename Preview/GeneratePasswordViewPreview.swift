#if DEBUG
import SwiftUI

struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            GeneratePasswordView { _ in }
                .preferredColorScheme(.light)
            
            GeneratePasswordView { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
