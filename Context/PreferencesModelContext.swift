import Crypto
import Preferences
import Store

#if os(macOS)
struct PreferencesModelContext {
    
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func preferencesUnlockedModel(vault: Vault) -> SettingsModel {
        let context = SettingsUnlockedModelContext(lockVault: {})
        return SettingsModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, context: context)
    }
    
}
#endif
