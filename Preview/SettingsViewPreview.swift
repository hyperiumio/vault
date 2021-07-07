#if DEBUG
import SwiftUI

struct SettingsViewPreview: PreviewProvider {
    
    static let biometrySettingsDependency = BiometrySettingsDependencyStub()
    static let masterPasswordSettingsDependency = MasterPasswordSettingsDependencyStub()
    static let settingsDependency = SettingsDependencyStub(keychainAvailablity: .notEnrolled, isBiometricUnlockEnabled: false, biometrySettingsDependency: biometrySettingsDependency, masterPasswordSettingsDependency: masterPasswordSettingsDependency)
    static let settingsState = SettingsState(dependency: settingsDependency)
    
    static var previews: some View {
        SettingsView(settingsState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SettingsView(settingsState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif

