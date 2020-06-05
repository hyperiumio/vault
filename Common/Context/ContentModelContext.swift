import Crypto
import Foundation
import Preferences

class ContentModelContext {
    
    private let masterKeyUrl: URL
    private let vaultUrl: URL
    private let preferencesStore: PreferencesStore
    weak var responder: ContentModelContextResponder?
    
    init(masterKeyUrl: URL, vaultUrl: URL, preferencesStore: PreferencesStore) {
        self.masterKeyUrl = masterKeyUrl
        self.vaultUrl = vaultUrl
        self.preferencesStore = preferencesStore
    }
    
    func setupModel() -> SetupModel {
        return SetupModel(masterKeyUrl: masterKeyUrl)
    }
    
    func lockedModel() -> LockedModel {
        return LockedModel(masterKeyUrl: masterKeyUrl, preferencesStore: preferencesStore)
    }
    
    func unlockedModel(masterKey: MasterKey) -> UnlockedModel {
        let context = UnlockedModelContext(vaultUrl: vaultUrl, masterKey: masterKey, preferencesStore: preferencesStore)
        return UnlockedModel(context: context)
    }
    
}

protocol ContentModelContextResponder: class {
 
    var isLockable: Bool { get }
    
    func lock()
    
}

struct UnlockedModelContext {
    
    let vaultUrl: URL
    let masterKey: MasterKey
    let preferencesStore: PreferencesStore
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
    func preferencesModel() -> PreferencesModel {
        let context = PreferencesModelContext(store: preferencesStore)
        return PreferencesModel(context: context)
    }
    
}
