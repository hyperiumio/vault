#if DEBUG
import SwiftUI

struct SettingsViewPreview: PreviewProvider {
    
    static let model = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, biometricAvailablity: .faceID, isBiometricUnlockEnabled: true)
    
    static var previews: some View {
        Text("foo")
    }
    
}
#endif
