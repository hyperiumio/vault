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
    
    struct BiometrySettingsServiceStub: BiometrySettingsDependency {
        
        func save(isBiometricUnlockEnabled: Bool) async {}
        
    }
    
    struct MasterPasswordSettingsServiceStub: MasterPasswordSettingsDependency {
        
        func changeMasterPassword(to masterPassword: String) async throws {}
        
    }
    
    struct SettingsService: SettingsDependency {
        
        let biometryType = BiometryType.touchID as BiometryType?
        let isBiometricUnlockEnabled = true
        let biometrySettingsDependency = BiometrySettingsServiceStub() as BiometrySettingsDependency
        let masterPasswordSettingsDependency = MasterPasswordSettingsServiceStub() as MasterPasswordSettingsDependency
        
    }
    
}
#endif
