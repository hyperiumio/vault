class VaultItemLoadedModelContext {
    
    private let saveOperation: SaveVaultItemOperation
    
    init(saveOperation: SaveVaultItemOperation) {
        self.saveOperation = saveOperation
    }
    
    func vaultItemEditModel(vaultItem: VaultItem) -> VaultItemEditModel {
        return VaultItemEditModel(vaultItem: vaultItem, saveOperation: saveOperation)
    }
    
}
