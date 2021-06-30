import Foundation

public actor PersistentDefaultsService<Store>: DefaultsService where Store: PersistenceProvider {
    
    private let store: Store
    
    public init(appGroup: String) throws {
        guard let store = Store(suiteName: appGroup) else {
            throw PreferencesError.invalidAppGroup
        }
        store.register(defaults: Store.defaults)
        
        self.store = store
    }
    
    public func set(isBiometricUnlockEnabled: Bool) async {
        store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    public func set(activeStoreID: UUID) async {
        store.activeStoreID = activeStoreID
    }
    
    public var defaults: Defaults {
        get async {
            Defaults(isBiometricUnlockEnabled: store.isBiometricUnlockEnabled, activeStoreID: store.activeStoreID)
        }
    }
    
}
