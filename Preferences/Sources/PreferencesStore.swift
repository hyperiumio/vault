import Foundation

protocol PreferencesStoreRepresentable: class {
    
    var isBiometricUnlockEnabled: Bool { get set }
    var activeVaultIdentifier: UUID? { get set }
    
}

class PreferencesStore: PreferencesStoreRepresentable {
    
    private let userDefaults: UserDefaultsRepresentable
    
    init(userDefaults: UserDefaultsRepresentable) {
        let defaults = [
            String.biometricUnlockEnabledKey: false
        ]
        userDefaults.register(defaults: defaults)
        
        self.userDefaults = userDefaults
    }
    
    var isBiometricUnlockEnabled: Bool {
        get {
            userDefaults.bool(forKey: .biometricUnlockEnabledKey)
        }
        set(isBiometricUnlockEnabled) {
            userDefaults.set(isBiometricUnlockEnabled, forKey: .biometricUnlockEnabledKey)
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

protocol UserDefaultsRepresentable {
    
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func register(defaults registrationDictionary: [String : Any])
    
}

extension UserDefaults: UserDefaultsRepresentable {}

private extension String {
    
    static var biometricUnlockEnabledKey: Self { "BiometricUnlockEnabled" }
    static var activeVaultIdentifier: Self { "ActiveVaultIdentifier" }
    
}
