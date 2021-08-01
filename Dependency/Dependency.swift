import Configuration
import Crypto
import Foundation
import Preferences
import Persistence

struct Dependency {
    
    let bootstrapService: BootstrapServiceProtocol
    let settingsService: SettingsServiceProtocol
    let unlockService: UnlockServiceProtocol
    let passwordService: PasswordServiceProtocol
    let setupService: SetupServiceProtocol
    let storeItemService: StoreItemServiceProtocol
    
}

extension Dependency {
    
    static let production: Self = {
        let userDefaults = UserDefaults(suiteName: Configuration.appGroup)!
        let defaults = Defaults(store: userDefaults)
        let cryptor = Cryptor(keychainAccessGroup: Configuration.appGroup)
        let store = Store(containerDirectory: Configuration.storeDirectory)
        let bootstrapService = BootstrapService(defaults: defaults, store: store)
        let settingsService = SettingsService(defaults: defaults, cryptor: cryptor, store: store)
        let unlockService = UnlockService(defaults: defaults, cryptor: cryptor, store: store)
        let passwordService = PasswordService()
        let setupService = SetupService(defaults: defaults, cryptor: cryptor, store: store)
        let storeItemService = StoreItemService(defaults: defaults, cryptor: cryptor, store: store)
        
        return Self(bootstrapService: bootstrapService, settingsService: settingsService, unlockService: unlockService, passwordService: passwordService, setupService: setupService, storeItemService: storeItemService)
    }()
    
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
