#if DEBUG
import SwiftUI

struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        PasswordGeneratorView { _ in }
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
