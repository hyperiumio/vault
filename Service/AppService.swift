import Configuration
import Crypto
import Foundation
import Preferences
import Store

struct AppService: AppDependency {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init() throws {
        guard let containerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Configuration.appGroup)?.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true) else {
                  fatalError()
              }
        
        self.defaults = try Defaults<UserDefaults>(appGroup: Configuration.appGroup)
        self.keychain = Keychain(accessGroup: Configuration.appGroup)
        self.store = Store(containerDirectory: containerDirectory)
    }
    
    var needsSetup: Bool {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                return false
            }
            return try await store.storeExists(storeID: storeID)
        }
    }
    
    var setupDependency: SetupDependency {
        SetupService(defaults: defaults, keychain: keychain, store: store)
    }
    
    var lockedDependency: LockedDependency {
        LockedService(defaults: defaults, keychain: keychain, store: store)
    }
    
    var unlockedDependency: UnlockedDependency {
        UnlockedService()
    }
    
}

extension UserDefaults: PersistenceProvider {}
