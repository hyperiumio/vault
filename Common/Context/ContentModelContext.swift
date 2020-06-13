import Crypto
import Foundation
import Preferences

class ContentModelContext {
    
    private let masterKeyUrl: URL
    private let vaultUrl: URL
    private let preferencesManager: PreferencesManager
    weak var responder: ContentModelContextResponder?
    
    init(masterKeyUrl: URL, vaultUrl: URL, preferencesManager: PreferencesManager) {
        self.masterKeyUrl = masterKeyUrl
        self.vaultUrl = vaultUrl
        self.preferencesManager = preferencesManager
    }
    
    func setupModel() -> SetupModel {
        return SetupModel(masterKeyUrl: masterKeyUrl)
    }
    
    func lockedModel() -> LockedModel {
        return LockedModel(masterKeyUrl: masterKeyUrl, preferencesManager: preferencesManager)
    }
    
    func unlockedModel(masterKey: MasterKey) -> UnlockedModel {
        let context = UnlockedModelContext(vaultUrl: vaultUrl, masterKey: masterKey, preferencesManager: preferencesManager)
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
    let preferencesManager: PreferencesManager
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
    func preferencesModel() -> PreferencesModel {
        let context = PreferencesModelContext(preferencesManager: preferencesManager)
        return PreferencesModel(context: context)
    }
    
}
