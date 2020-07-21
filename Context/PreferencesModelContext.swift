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
    
    func preferencesUnlockedModel(vault: Vault<SecureDataCryptor>) -> SettingsUnlockedModel {
        let context = SettingsUnlockedModelContext(lockVault: {})
        return SettingsUnlockedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, context: context)
    }
    
}
#endif
