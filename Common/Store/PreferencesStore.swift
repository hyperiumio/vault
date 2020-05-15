import Combine
import Foundation

class PreferencesStore {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var isBiometricUnlockEnabled: Bool {
        get {
            return userDefaults.bool(forKey: .isBiometricUnlockEnabled)
        }
        set(isBiometricUnlockEnabled) {
            userDefaults.set(isBiometricUnlockEnabled, forKey: .isBiometricUnlockEnabled)
        }
    }
    
    var preferences: Preferences {
        return Preferences(from: self)
    }
    
}

private extension String {
    
    static let isBiometricUnlockEnabled = "isBiometricUnlockEnabled"
    
}

struct Preferences {
    
    let isBiometricUnlockEnabled: Bool
    
    fileprivate init(from store: PreferencesStore) {
        self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
    }
    
}
