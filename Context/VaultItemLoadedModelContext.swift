import Crypto
import Store

struct VaultItemLoadedModelContext {
    
    private let vault: Vault<SecureDataCryptor>
    
    init(vault: Vault<SecureDataCryptor>) {
        self.vault = vault
    }
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vaultItem: vaultItem, vault: vault)
    }
    
}
