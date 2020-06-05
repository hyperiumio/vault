import Crypto
import Foundation
import Store

struct VaultItemModelContext {
    
    let itemInfo: VaultItemStore<SecureDataCryptor>.ItemInfo
    let store: VaultItemStore<SecureDataCryptor>
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(itemInfo: itemInfo, store: store)
    }
    
    func vaultItemLoadedModelContext() -> VaultItemLoadedModelContext {
        return VaultItemLoadedModelContext(store: store)
    }
    
}
