import Crypto
import Store

struct UnlockedModel {
    
    let vault: Vault<SecureDataCryptor>
    let vaulItemCollectionModel: VaultItemCollectionModel

    init(vault: Vault<SecureDataCryptor>, context: UnlockedModelContext) {
        self.vault = vault
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
    }
    
}
