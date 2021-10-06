import Foundation

public struct Defaults {
    
    public let activeStoreID: UUID?
    public let touchIDUnlock: Bool
    public let faceIDUnlock: Bool
    public let watchUnlock: Bool
    public let hidePasswords: Bool
    public let clearPasteboard: Bool
    
    init(from userDefaults: UserDefaults) {
        self.activeStoreID = userDefaults.string(forKey: DefaultsKey.activeStoreID.rawValue).map(UUID.init) ?? nil
        self.touchIDUnlock = userDefaults.bool(forKey: DefaultsKey.touchIDUnlock.rawValue)
        self.faceIDUnlock = userDefaults.bool(forKey: DefaultsKey.faceIDUnlock.rawValue)
        self.watchUnlock = userDefaults.bool(forKey: DefaultsKey.watchUnlock.rawValue)
        self.hidePasswords = userDefaults.bool(forKey: DefaultsKey.hidePasswords.rawValue)
        self.clearPasteboard = userDefaults.bool(forKey: DefaultsKey.clearPasteboard.rawValue)
    }
    
}
