import Crypto
import Foundation
import Preferences
import Store

class ContentModelContext {
    
    weak var responder: ContentModelContextResponder?
    
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func setupModel(vaultDirectory: URL) -> SetupModel {
        return SetupModel(vaultDirectory: vaultDirectory, preferencesManager: preferencesManager)
    }
    
    func lockedModel(vaultLocation: Vault<SecureDataCryptor>.Location) -> LockedModel {
        return LockedModel(vaultLocation: vaultLocation, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(vault: Vault<SecureDataCryptor>) -> UnlockedModel {
        let context = UnlockedModelContext(store: vault.store, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return UnlockedModel(vaultLocation: vault.location, context: context)
    }
    
}

protocol ContentModelContextResponder: class {
 
    var isLockable: Bool { get }
    
    func lock()
    
}
