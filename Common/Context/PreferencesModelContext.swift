import Crypto
import Store
import Preferences

struct PreferencesModelContext {
    
    let vault: Vault<SecureDataCryptor>
    let preferencesManager: PreferencesManager
    let biometricKeychain: BiometricKeychain
    
    func loadingModel() -> PreferencesLoadingModel {
        return PreferencesLoadingModel(preferencesManager: preferencesManager)
    }
    
    func loadedModel() -> PreferencesLoadedModel {
        return PreferencesLoadedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
}
