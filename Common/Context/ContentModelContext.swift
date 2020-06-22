import Crypto
import Foundation
import Preferences
import Store

class ContentModelContext {
    
    weak var responder: ContentModelContextResponder?
    
    let preferencesManager: PreferencesManager
    let biometricKeychain: BiometricKeychain
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func setupModel(vaultDirectory: URL) -> SetupModel {
        return SetupModel(vaultDirectory: vaultDirectory, preferencesManager: preferencesManager)
    }
    
    func lockedModel(vaultLocation: VaultLocation) -> LockedModel {
        return LockedModel(vaultLocation: vaultLocation, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(vault: Vault<SecureDataCryptor>) -> UnlockedModel {
        let context = UnlockedModelContext(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        
        #if canImport(AppKit)
        return UnlockedModel(vault: vault, context: context)
        #endif
        
        #if canImport(UIKit)
        return UnlockedModel(vaultLocation: vault.location, context: context)
        #endif
    }
    
}

protocol ContentModelContextResponder: class {
 
    var isLockable: Bool { get }
    var canShowPreferences: Bool { get }
    
    func lock()
    func showPreferences()
    
}
