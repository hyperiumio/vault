import Crypto
import Foundation
import Store

struct VaultItemModelContext {
    
    private let vault: Vault<SecureDataCryptor>
    private let itemToken: VaultItemToken<SecureDataCryptor>
    
    init(vault: Vault<SecureDataCryptor>, itemToken: VaultItemToken<SecureDataCryptor>) {
        self.vault = vault
        self.itemToken = itemToken
    }
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(itemToken: itemToken, vault: vault)
    }
    
    func vaultItemLoadedModel(vaultItem: VaultItem) -> VaultItemLoadedModel {
        let context = VaultItemLoadedModelContext(vault: vault)
        return VaultItemLoadedModel(vaultItem: vaultItem, context: context)
    }
    
}
