import Foundation

public actor Defaults {
    
    private let store: PersistenceProvider
    
    public init(store: PersistenceProvider) {
        let defaults =  [
            String.biometricUnlockEnabledKey: false
        ]
        store.register(defaults: defaults)
        
        self.store = store
    }
    
    public var isBiometricUnlockEnabled: Bool {
        get async {
            store.bool(forKey: .biometricUnlockEnabledKey)
        }
    }
    
    public var activeStoreID: UUID? {
        get async {
            guard let storeID = store.string(forKey: .activeStoreIDKey) else {
                return nil
            }
            return UUID(uuidString: storeID)
        }
    }
    
    public func set(isBiometricUnlockEnabled: Bool) async {
        store.set(isBiometricUnlockEnabled, forKey: .biometricUnlockEnabledKey)
    }
    
    public func set(activeStoreID: UUID?) async {
        store.set(activeStoreID?.uuidString, forKey: .activeStoreIDKey)
    }
    
}

private extension String {
    
    static var biometricUnlockEnabledKey: Self { "BiometricUnlockEnabled" }
    static var activeStoreIDKey: Self { "ActiveStoreID" }
    
}
