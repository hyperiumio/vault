import Configuration
import Crypto
import Foundation
import Preferences
import Store

actor BootstrapService {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init() throws {
        self.defaults = try Defaults<UserDefaults>(appGroup: Configuration.appGroup)
        self.keychain = Keychain(accessGroup: Configuration.appGroup)
        self.store = Store(containerDirectory: Configuration.storeDirectory!)
    }
    
}

extension BootstrapService: AppDependency {
    
    var didCompleteSetup: Bool {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                return false
            }
            return try await store.storeExists(storeID: storeID)
        }
    }
    
    nonisolated func setupDependency() -> SetupDependency {
        SetupService(defaults: defaults, keychain: keychain, store: store)
    }
    
    nonisolated func lockedDependency() -> LockedDependency {
        MasterKeyDecryptionService(defaults: defaults, keychain: keychain, store: store)
    }
    
    nonisolated func unlockedDependency(masterKey: MasterKey) -> UnlockedDependency {
        UnlockedService()
    }
    
}

extension UserDefaults: PersistenceProvider {}

#if DEBUG
actor BootstrapServiceStub {}

extension BootstrapServiceStub: AppDependency {
    
    var didCompleteSetup: Bool {
        get async throws {
            true
        }
    }
    
    nonisolated func setupDependency() -> SetupDependency {
        SetupServiceStub()
    }
    
    nonisolated func lockedDependency() -> LockedDependency {
        MasterKeyDecryptionServiceStub()
    }
    
    nonisolated func unlockedDependency(masterKey: MasterKey) -> UnlockedDependency {
        UnlockedServiceStub()
    }
    
}
#endif
