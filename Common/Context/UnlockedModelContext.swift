import Crypto
import Preferences
import Store

struct UnlockedModelContext {
    
    let store: VaultItemStore<SecureDataCryptor>
    let preferencesManager: PreferencesManager
    let biometricKeychain: BiometricKeychain
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(store: store)
    }
    
    func preferencesModel() -> PreferencesModel {
        let context = PreferencesModelContext(preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return PreferencesModel(context: context)
    }
    
}
