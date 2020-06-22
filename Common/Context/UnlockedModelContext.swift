import Crypto
import Preferences
import Store

struct UnlockedModelContext {
    
    let vault: Vault<SecureDataCryptor>
    let preferencesManager: PreferencesManager
    let biometricKeychain: BiometricKeychain
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(vault: vault)
    }
    
    func preferencesModel() -> PreferencesModel {
        let context = PreferencesModelContext(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return PreferencesModel(context: context)
    }
    
}
