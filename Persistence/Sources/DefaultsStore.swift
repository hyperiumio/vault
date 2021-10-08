import Foundation

public actor DefaultsStore {
    
    private let userDefaults: UserDefaults
    
    public init(appGroup: String) {
        self.userDefaults = UserDefaults(suiteName: appGroup)!
    }
    
    public var value: Defaults {
        get async {
            Defaults(from: userDefaults)
        }
    }
    
    public func set(activeStoreID: UUID?) async {
        userDefaults.set(activeStoreID?.uuidString, forKey: DefaultsKey.activeStoreID.rawValue)
    }
    
    public func set(biometricUnlock: Bool) async {
        userDefaults.set(biometricUnlock, forKey: DefaultsKey.biometricUnlock.rawValue)
    }
    
    public func set(watchUnlock: Bool) async {
        userDefaults.set(watchUnlock, forKey: DefaultsKey.watchUnlock.rawValue)
    }
    
    public func set(hidePasswords: Bool) async {
        userDefaults.set(hidePasswords, forKey: DefaultsKey.hidePasswords.rawValue)
    }
    
    public func set(clearPasteboard: Bool) async {
        userDefaults.set(clearPasteboard, forKey: DefaultsKey.clearPasteboard.rawValue)
    }
    
}
