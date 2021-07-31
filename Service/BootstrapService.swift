import Foundation
import Preferences
import Store

protocol BootstrapServiceProtocol {
    
    var didCompleteSetup: Bool { get async throws }
    
}


struct BootstrapService: BootstrapServiceProtocol {
    
    private let defaults: Defaults
    private let store: Store
    
    init(defaults: Defaults, store: Store) {
        self.defaults = defaults
        self.store = store
    }
    
    var didCompleteSetup: Bool {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                return false
            }
            return try await store.storeExists(storeID: storeID)
        }
    }
    
}

#if DEBUG
actor BootstrapServiceStub {}

extension BootstrapServiceStub: BootstrapServiceProtocol {
    
    var didCompleteSetup: Bool {
        get async throws {
            true
        }
    }
    
}
#endif
