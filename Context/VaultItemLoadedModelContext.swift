import Crypto
import Store

struct VaultItemLoadedModelContext {
    
    private let vault: Vault
    
    init(vault: Vault) {
        self.vault = vault
    }
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vault: vault, vaultItem: vaultItem)
    }
    
}
