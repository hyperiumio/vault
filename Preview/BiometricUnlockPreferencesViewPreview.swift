#if DEBUG
import SwiftUI

struct BiometricUnlockPreferencesPreview: PreviewProvider {
    
    static let model = BiometricUnlockPreferencesModelStub(password: "", status: .none, biometricType: .faceID)
    
    static var previews: some View {
        BiometricUnlockPreferencesView(model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
