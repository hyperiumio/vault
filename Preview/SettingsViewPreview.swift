#if DEBUG
import SwiftUI

struct SettingsViewPreview: PreviewProvider {
    
    static let model = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, keychainAvailability: .faceID, isBiometricUnlockEnabled: true)
    
    static var previews: some View {
        Group {
            SettingsView(model)
                .preferredColorScheme(.light)
            
            SettingsView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
