import Foundation

public actor DefaultsStore {
    
    private let userDefaults: UserDefaults
    
    public init(appGroup: String) {
        self.userDefaults = UserDefaults(suiteName: appGroup)!
    }
    
    public var value: Defaults {
        get async {
            let activeStoreID = userDefaults.string(forKey: .activeStoreID).map(UUID.init) ?? nil
            let biometryUnlock = userDefaults.string(forKey: .biometryUnlock).map(Defaults.BiometryUnlock.init) ?? nil
            let externalUnlock = userDefaults.string(forKey: .externalUnlock).map(Defaults.ExternalUnlock.init) ?? nil
            
            return Defaults(activeStoreID: activeStoreID, biometryUnlock: biometryUnlock, externalUnlock: externalUnlock)
        }
    }
    
    public func set(activeStoreID: UUID?) async {
        userDefaults.set(activeStoreID?.uuidString, forKey: .activeStoreID)
    }
    
    public func set(biometryUnlock: Defaults.BiometryUnlock) {
        userDefaults.set(biometryUnlock, forKey: .biometryUnlock)
    }
    
    public func set(externalUnlock: Defaults.ExternalUnlock) {
        userDefaults.set(externalUnlock, forKey: .externalUnlock)
    }
    
}

private extension String {
    
    static var activeStoreID: Self { "ActiveStoreID" }
    static var biometryUnlock: Self { "BiometryUnlock" }
    static var externalUnlock: Self { "ExternalUnlock" }
    
}
