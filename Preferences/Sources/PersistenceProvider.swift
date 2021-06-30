import Foundation

public protocol PersistenceProvider: AnyObject {
    
    init?(suiteName suitename: String?)
    
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func register(defaults registrationDictionary: [String : Any])
    
}

extension PersistenceProvider {
    
    var isBiometricUnlockEnabled: Bool {
        get {
            bool(forKey: .biometricUnlockEnabledKey)
        }
        set(isBiometricUnlockEnabled) {
            set(isBiometricUnlockEnabled, forKey: .biometricUnlockEnabledKey)
        }
    }
    
    var activeStoreID: UUID? {
        get {
            guard let storeID = string(forKey: .activeStoreIDKey) else {
                return nil
            }
            return UUID(uuidString: storeID)
        }
        set(storeID) {
            set(storeID?.uuidString, forKey: .activeStoreIDKey)
        }
    }
    
    static var defaults: [String: Any] {
        [
            .biometricUnlockEnabledKey: false
        ]
    }
    
}

private extension String {
    
    static var biometricUnlockEnabledKey: Self { "BiometricUnlockEnabled" }
    static var activeStoreIDKey: Self { "ActiveStoreID" }
    
}
