import Combine
import Crypto
import Store

class UnlockedModel: ObservableObject {
    
    let vaultLocation: VaultLocation
    let vaulItemCollectionModel: VaultItemCollectionModel
    let preferencesModel: PreferencesModel
    
    init(vaultLocation: VaultLocation, context: UnlockedModelContext) {
        self.vaultLocation = vaultLocation
        self.vaulItemCollectionModel = context.vaultItemCollectionModel()
        self.preferencesModel = context.preferencesModel()
    }
    
}
