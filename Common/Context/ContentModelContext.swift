import CryptoKit
import Foundation

class ContentModelContext {
    
    let masterKeyUrl: URL
    let vaultUrl: URL
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
    
    func unlockedModel(masterKey: SymmetricKey) -> UnlockedModel {
        return UnlockedModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
}

protocol ContentModelContextResponder: class {
 
    var isLockable: Bool { get }
    
    func lock()
    
}
