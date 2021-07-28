import Configuration
import Crypto
import Foundation
import Preferences
import Store

struct Dependency {
    
    let bootstrapService: BootstrapServiceProtocol
    let settingsService: SettingsServiceProtocol
    let unlockService: UnlockServiceProtocol
    let passwordService: PasswordServiceProtocol
    let setupService: SetupServiceProtocol
    let storeItemService: StoreItemServiceProtocol
    
}

extension Dependency {
    
    static func production() -> Self {
        let defaults = try! Defaults<UserDefaults>(appGroup: Configuration.appGroup)
        let keychain = Keychain(accessGroup: Configuration.appGroup)
        let store = Store(containerDirectory: Configuration.storeDirectory!)
        let bootstrapService = BootstrapService(defaults: defaults, store: store)
        let settingsService = SettingsService(defaults: defaults, keychain: keychain, store: store)
        let unlockService = UnlockService(defaults: defaults, keychain: keychain, store: store)
        let passwordService = PasswordService()
        let setupService = SetupService(defaults: defaults, keychain: keychain, store: store)
        let storeItemService = StoreItemService(defaults: defaults, keychain: keychain, store: store)
        
        return Self(bootstrapService: bootstrapService, settingsService: settingsService, unlockService: unlockService, passwordService: passwordService, setupService: setupService, storeItemService: storeItemService)
    }
    
}

extension UserDefaults: PersistenceProvider {}

#if DEBUG
extension Dependency {
    
    static let stub: Self = {
        let bootstrapService = BootstrapServiceStub()
        let settingsService = SettingsServiceStub()
        let unlockService = UnlockServiceStub()
        let passwordService = PasswordServiceStub()
        let setupService = SetupServiceStub()
        let storeItemService = StoreItemServiceStub()
        
        return Self(bootstrapService: bootstrapService, settingsService: settingsService, unlockService: unlockService, passwordService: passwordService, setupService: setupService, storeItemService: storeItemService)
    }()
    
}
#endif
