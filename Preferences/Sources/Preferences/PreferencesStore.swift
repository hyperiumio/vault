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
    
}

private extension String {
    
    static var isBiometricUnlockEnabledKey: Self { "isBiometricUnlockEnabled" }
    
}
