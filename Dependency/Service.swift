import Crypto
import Foundation
import Model
import Preferences

struct Service {
    
    let store: StoreService
    let defaults: DefaultsService
    let security: SecurityService
    
    init(store: StoreService, defaults: DefaultsService, security: SecurityService) {
        self.store = store
        self.defaults = defaults
        self.security = security
    }
    
    init() throws {
        store = try PersistentStoreService()
        defaults = try PersistentDefaultsService<UserDefaults>(appGroup: .appGroup)
        security = try SystemSecurityService()
    }
    
}

extension UserDefaults: Preferences.PersistenceProvider {}

private extension String {
    
    static var vaults: Self { "Vaults" }
    
    #if os(iOS)
    static var appGroup: Self { "group.io.hyperium.vault" }
    #endif

    #if os(macOS)
    static var appGroup: Self { "HX3QTQLX65.io.hyperium.vault" }
    #endif
    
}
