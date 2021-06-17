import Crypto
import Foundation
import Preferences
import Model
import Sort

@MainActor
struct QuickAccessDependency: QuickAccessStateDependency {
    
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(preferences: Preferences, keychain: Keychain) {
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func quickAccessLockedState(store: Store) -> QuickAccessLockedState {
        QuickAccessLockedState(store: store, preferences: preferences, keychain: keychain)
    }
    
    func quickAccessUnlockedState(vaultItems: [StoreItemInfo: [LoginItem]]) -> QuickAccessUnlockedState {
        QuickAccessUnlockedState(vaultItems: vaultItems)
    }
    
}
