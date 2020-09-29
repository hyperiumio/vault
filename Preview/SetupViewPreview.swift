#if DEBUG
import SwiftUI

struct SetupViewPreview: PreviewProvider {
    
    static let model = SetupModelStub(password: "", repeatedPassword: "", biometricUnlockEnabled: false, passwordStatus: .insecure, keychainAvailability: .faceID)
    
    static var previews: some View {
        Group {
            SetupView(model)
                .preferredColorScheme(.light)
            
            SetupView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
