#if DEBUG
import SwiftUI

struct BiometricUnlockPreferencesPreview: PreviewProvider {
    
    static let model = BiometricUnlockPreferencesModelStub(password: "", status: .none, biometricType: .faceID)
    
    static var previews: some View {
        Group {
            BiometricUnlockPreferencesView(model)
                .preferredColorScheme(.light)
            
            BiometricUnlockPreferencesView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
