import Crypto
import Foundation
import Preferences
import Storage
import Sort

struct QuickAccessDependency: QuickAccessModelDependency {
    
    private let vaultContainerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func quickAccessLockedModel(vaultID: UUID) -> QuickAccessLockedModel {
        QuickAccessLockedModel(vaultID: vaultID, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
    func quickAccessUnlockedModel(vaultItems: [SecureContainerInfo: [LoginItem]]) -> QuickAccessUnlockedModel {
        QuickAccessUnlockedModel(vaultItems: vaultItems)
    }
    
}
