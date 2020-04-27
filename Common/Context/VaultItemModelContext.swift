import Combine

class VaultItemModelContext {
    
    private let saveOperation: SaveVaultItemOperation
    private let loadOperation: LoadVaultItemOperation
    
    init(saveOperation: SaveVaultItemOperation, loadOperation: LoadVaultItemOperation, reload: @escaping () -> Void) {
        self.saveOperation = saveOperation
        self.loadOperation = loadOperation
    }
    
    func vaultItemLoadingModel() -> VaultItemLoadingModel {
        return VaultItemLoadingModel(loadOperation: loadOperation)
    }
    
    func vaultItemLoadedModelContext() -> VaultItemLoadedModelContext {
        return VaultItemLoadedModelContext(saveOperation: saveOperation)
    }
    
}
