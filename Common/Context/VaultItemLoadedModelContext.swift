import Crypto
import Store

struct VaultItemLoadedModelContext {
    
    let vault: Vault<SecureDataCryptor>
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vaultItem: vaultItem, vault: vault)
    }
    
}
