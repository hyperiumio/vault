#if DEBUG
import Crypto
import SwiftUI

struct SettingsViewPreview: PreviewProvider {
    
    static let settingsDependency = SettingsService()
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

extension SettingsViewPreview {
    
    actor BiometrySettingsService: BiometrySettingsDependency {
        
        func save(isBiometricUnlockEnabled: Bool) async {}
        
    }
    
    actor MasterPasswordSettingsService: MasterPasswordSettingsDependency {
        
        func changeMasterPassword(to masterPassword: String) async throws {}
        
    }
    
    actor SettingsService: SettingsDependency {
        
        let biometryType = BiometryType.touchID as BiometryType?
        let isBiometricUnlockEnabled = true
        
        nonisolated func biometrySettingsDependency() -> BiometrySettingsDependency {
            BiometrySettingsService()
        }
        
        nonisolated func masterPasswordSettingsDependency() -> MasterPasswordSettingsDependency {
            MasterPasswordSettingsService()
        }
        
    }
    
}
#endif
