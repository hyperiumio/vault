import Foundation

public struct Preferences: Equatable {
    
    public let isBiometricUnlockEnabled: Bool
    public let activeVaultIdentifier: UUID?
    
    init(from store: PreferencesStore) {
        self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
        self.activeVaultIdentifier = store.activeVaultIdentifier
    }
    
}
