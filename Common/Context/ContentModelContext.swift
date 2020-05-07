import Crypto
import Foundation

class ContentModelContext {
    
    private let masterKeyUrl: URL
    private let vaultUrl: URL
    weak var responder: ContentModelContextResponder?
    
    init(masterKeyUrl: URL, vaultUrl: URL) {
        self.masterKeyUrl = masterKeyUrl
        self.vaultUrl = vaultUrl
    }
    
    func setupModel() -> SetupModel {
        return SetupModel(masterKeyUrl: masterKeyUrl)
    }
    
    func lockedModel() -> LockedModel {
        return LockedModel(masterKeyUrl: masterKeyUrl)
    }
    
    func unlockedModel(masterKey: MasterKey) -> UnlockedModel {
        let context = UnlockedModelContext(vaultUrl: vaultUrl, masterKey: masterKey)
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
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
}
