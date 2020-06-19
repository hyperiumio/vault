import Crypto
import Store

struct UnlockedModel {
    
    let vaultLocation: Vault<SecureDataCryptor>.Location
    let vaulItemCollectionModel: VaultItemCollectionModel

    init(vaultLocation: Vault<SecureDataCryptor>.Location, context: UnlockedModelContext) {
        self.vaultLocation = vaultLocation
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
    }
    
}
