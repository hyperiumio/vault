import Crypto
import Foundation
import Store

struct VaultItemModelContext {
    
    let itemToken: VaultItemToken<SecureDataCryptor>
    let vault: Vault<SecureDataCryptor>
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(itemToken: itemToken, vault: vault)
    }
    
    func vaultItemLoadedModelContext() -> VaultItemLoadedModelContext {
        return VaultItemLoadedModelContext(vault: vault)
    }
    
}
