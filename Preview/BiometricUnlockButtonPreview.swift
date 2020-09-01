#if DEBUG
import SwiftUI

struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricUnlockButton(.touchID) {}
            
            BiometricUnlockButton(.faceID) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
