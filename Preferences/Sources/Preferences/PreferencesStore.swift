import Foundation

class PreferencesStore {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        let defaults = [
            String.isBiometricUnlockEnabledKey: false
        ]
        userDefaults.register(defaults: defaults)
        
        self.userDefaults = userDefaults
    }
    
    var isBiometricUnlockEnabled: Bool {
        get {
            return userDefaults.bool(forKey: .isBiometricUnlockEnabledKey)
        }
        set(isBiometricUnlockEnabled) {
            userDefaults.set(isBiometricUnlockEnabled, forKey: .isBiometricUnlockEnabledKey)
        }
    }
    
    var activeVaultIdentifier: UUID? {
        get {
            guard let vaultIdentifier = userDefaults.string(forKey: .activeVaultIdentifier) else {
                return nil
            }
            return UUID(uuidString: vaultIdentifier)
        }
        set(activeVaultIdentifier) {
            userDefaults.set(activeVaultIdentifier?.uuidString, forKey: .activeVaultIdentifier)
        }
    }
    
}

private extension String {
    
    static var isBiometricUnlockEnabledKey: Self { "isBiometricUnlockEnabled" }
    static var activeVaultIdentifier: Self { "activeVaultIdentifier" }
    
}
