struct UnlockedModel {
    
    let vaulItemCollectionModel: VaultItemCollectionModel

    init(context: UnlockedModelContext) {
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
    }
    
}
