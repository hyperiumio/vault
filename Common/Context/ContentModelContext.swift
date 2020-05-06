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
        return UnlockedModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
}

protocol ContentModelContextResponder: class {
 
    var isLockable: Bool { get }
    
    func lock()
    
}
