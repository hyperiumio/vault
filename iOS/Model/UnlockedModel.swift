import Combine
import Crypto
import Store

class UnlockedModel: ObservableObject {
    
    let vaultLocation: Vault<SecureDataCryptor>.Location
    let vaulItemCollectionModel: VaultItemCollectionModel
    let preferencesModel: PreferencesModel
    
    init(vaultLocation: Vault<SecureDataCryptor>.Location, context: UnlockedModelContext) {
        self.vaultLocation = vaultLocation
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
        self.preferencesModel = context.preferencesModel()
    }
    
}
