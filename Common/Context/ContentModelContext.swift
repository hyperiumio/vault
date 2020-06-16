import Crypto
import Foundation
import Preferences

class ContentModelContext {
    
    weak var responder: ContentModelContextResponder?
    
    private let masterKeyUrl: URL
    private let vaultUrl: URL
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(masterKeyUrl: URL, vaultUrl: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.masterKeyUrl = masterKeyUrl
        self.vaultUrl = vaultUrl
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func setupModel() -> SetupModel {
        return SetupModel(masterKeyUrl: masterKeyUrl)
    }
    
    func lockedModel() -> LockedModel {
        return LockedModel(masterKeyUrl: masterKeyUrl, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(masterKey: MasterKey) -> UnlockedModel {
        let context = UnlockedModelContext(vaultUrl: vaultUrl, masterKey: masterKey, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
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
    let biometricKeychain: BiometricKeychain
    
    func vaultItemCollectionModel() -> VaultItemCollectionModel {
        return VaultItemCollectionModel(vaultUrl: vaultUrl, masterKey: masterKey)
    }
    
    func preferencesModel() -> PreferencesModel {
        let context = PreferencesModelContext(preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return PreferencesModel(context: context)
    }
    
}
