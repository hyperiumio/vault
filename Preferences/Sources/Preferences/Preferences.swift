public struct Preferences: Equatable {
    
    public let isBiometricUnlockEnabled: Bool
    
    init(from store: PreferencesStore) {
        self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
    }
    
}
