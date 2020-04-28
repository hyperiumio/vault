import Foundation

struct VaultItemModelContext {
    
    let itemId: UUID
    let vault: Vault
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(itemId: itemId, vault: vault)
    }
    
    func vaultItemLoadedModelContext() -> VaultItemLoadedModelContext {
        return VaultItemLoadedModelContext(vault: vault)
    }
    
}
