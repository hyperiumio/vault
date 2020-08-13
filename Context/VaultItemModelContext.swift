import Crypto
import Foundation
import Store

struct VaultItemModelContext {
    
    private let vault: Vault
    private let itemID: UUID
    
    init(vault: Vault, itemID: UUID) {
        self.vault = vault
        self.itemID = itemID
    }
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(vault: vault, itemID: itemID)
    }
    
    func vaultItemLoadedModel(vaultItem: VaultItem) -> VaultItemLoadedModel {
        let context = VaultItemLoadedModelContext(vault: vault)
        return VaultItemLoadedModel(vaultItem: vaultItem, context: context)
    }
    
}
