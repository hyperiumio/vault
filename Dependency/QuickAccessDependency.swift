import Crypto
import Foundation
import Preferences
import Persistence
import Sort

@MainActor
struct QuickAccessDependency: QuickAccessModelDependency {
    
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(preferences: Preferences, keychain: Keychain) {
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func quickAccessLockedModel(store: Store) -> QuickAccessLockedModel {
        QuickAccessLockedModel(store: store, preferences: preferences, keychain: keychain)
    }
    
    func quickAccessUnlockedModel(vaultItems: [StoreItemInfo: [LoginItem]]) -> QuickAccessUnlockedModel {
        QuickAccessUnlockedModel(vaultItems: vaultItems)
    }
    
}
