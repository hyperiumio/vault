import Combine

class UnlockedModel: ObservableObject {
    
    let vaulItemCollectionModel: VaultItemCollectionModel
    let preferencesModel: PreferencesModel
    
    init(context: UnlockedModelContext) {
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
        self.preferencesModel = PreferencesModel()
    }
    
}
