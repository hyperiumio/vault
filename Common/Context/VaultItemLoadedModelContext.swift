struct VaultItemLoadedModelContext {
    
    let vault: Vault
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vaultItem: vaultItem, vault: vault)
    }
    
}
