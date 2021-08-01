import Crypto
import Foundation
import Preferences
import Persistence

protocol UnlockServiceProtocol {
    
    var availableBiometry: BiometryType? { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    
}


struct UnlockService: UnlockServiceProtocol {
    
    private let defaults: Defaults
    private let cryptor: Cryptor
    private let store: Store
    
    init(defaults: Defaults, cryptor: Cryptor, store: Store) {
        self.defaults = defaults
        self.cryptor = cryptor
        self.store = store
    }
    
    var availableBiometry: BiometryType? {
        get async {
            switch await cryptor.biometryAvailablility {
            case .notAvailable, .notEnrolled:
                return nil
            case .enrolled(.touchID):
                return .touchID
            case .enrolled(.faceID):
                return .faceID
            }
        }
    }
    
    func unlockWithPassword(_ password: String) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        let derivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: storeID)
        try await cryptor.unlockWithPassword(password, token: derivedKeyContainer, id: storeID)
    }
    
    func unlockWithBiometry() async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        
        try await cryptor.unlockWithBiometry(id: storeID)
    }
    
}

extension UnlockService {
    
    enum Error: Swift.Error {
        
        case activeStoreIDMissing
        case derivedKeyMissing
        
    }
    
}

#if DEBUG
struct UnlockServiceStub: UnlockServiceProtocol {
   
    var availableBiometry: BiometryType? {
        get async {
            .faceID
        }
    }
    
    func unlockWithPassword(_ password: String) async throws {
        print(#function)
    }
    
    func unlockWithBiometry() async throws {
        print(#function)
    }
    
}
#endif
