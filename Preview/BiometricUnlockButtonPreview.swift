#if DEBUG
import SwiftUI

struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricUnlockButton(.touchID) {}
                .preferredColorScheme(.light)
            
            BiometricUnlockButton(.touchID) {}
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
