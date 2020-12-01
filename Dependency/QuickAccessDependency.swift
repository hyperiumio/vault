import Crypto
import Foundation
import Preferences
import Store

struct QuickAccessDependency: QuickAccessModelDependency {
    
    private let vaultContainerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func lockedModel(vaultID: UUID) -> LockedModel {
        LockedModel(vaultID: vaultID, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
    func credentialProviderModel(vault: Vault) -> CredentialProviderModel {
        CredentialProviderModel()
    }
    
}
