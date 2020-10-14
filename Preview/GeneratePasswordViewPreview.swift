#if DEBUG
import SwiftUI

struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            GeneratePasswordView { _, _, _ in }
                .preferredColorScheme(.light)
            
            GeneratePasswordView { _, _, _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
