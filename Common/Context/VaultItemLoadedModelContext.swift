import Crypto
import Store

struct VaultItemLoadedModelContext {
    
    let store: VaultItemStore<SecureDataCryptor>
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vaultItem: vaultItem, store: store)
    }
    
}
