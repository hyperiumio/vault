import Foundation

public class PreferencesStore {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public var isBiometricUnlockEnabled: Bool {
        get {
            return userDefaults.bool(forKey: .isBiometricUnlockEnabled)
        }
        set(isBiometricUnlockEnabled) {
            userDefaults.set(isBiometricUnlockEnabled, forKey: .isBiometricUnlockEnabled)
        }
    }
    
    public var preferences: Preferences {
        return Preferences(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
    }
    
}

private extension String {
    
    static let isBiometricUnlockEnabled = "isBiometricUnlockEnabled"
    
}

public struct Preferences {
    
    public let isBiometricUnlockEnabled: Bool
    
}
