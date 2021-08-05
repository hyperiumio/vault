import Foundation

public struct Defaults { // should be an actor
    
    private let store: PersistenceProvider
    
    public init(store: PersistenceProvider) {
        let defaults =  [
            String.biometricUnlockEnabled: false
        ]
        store.register(defaults: defaults)
        
        self.store = store
    }
    
    public var isBiometricUnlockEnabled: Bool {
        get async {
            store.bool(forKey: .biometricUnlockEnabled)
        }
    }
    
    public var activeStoreID: UUID? {
        get async {
            guard let storeID = store.string(forKey: .activeStoreID) else {
                return nil
            }
            return UUID(uuidString: storeID)
        }
    }
    
    public func set(isBiometricUnlockEnabled: Bool) async {
        store.set(isBiometricUnlockEnabled, forKey: .biometricUnlockEnabled)
    }
    
    public func set(activeStoreID: UUID?) async {
        store.set(activeStoreID?.uuidString, forKey: .activeStoreID)
    }
    
}

private extension String {
    
    static var biometricUnlockEnabled: Self { "BiometricUnlockEnabled" }
    static var activeStoreID: Self { "ActiveStoreID" }
    
}
