#if DEBUG
import SwiftUI

struct BiometrySettingsViewPreview: PreviewProvider {
    
    static let biometrySettingsDependency = BiometrySettingsDependencyStub()
    static let biometrySettingsState = BiometrySettingsState(biometryType: .faceID, isBiometricUnlockEnabled: false, dependency: biometrySettingsDependency)
    
    static var previews: some View {
        List {
            BiometrySettingsView(biometrySettingsState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BiometrySettingsView(biometrySettingsState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
