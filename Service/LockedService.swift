import Crypto
import Foundation
import Preferences
import Store

struct LockedService: LockedDependency {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
    }
    
    var biometryType: BiometryType? {
        get async {
            switch await keychain.availability() {
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
        guard let storeIDValue = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        let storeID = StoreID(storeIDValue)
        let masterKeyContainer = try await store.loadMasterKeyContainer(storeID: storeID)
        let derivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: storeID)
        let publicArguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
        let derivedKey = try await DerivedKey(from: password, with: publicArguments)
        _ = try MasterKey(from: masterKeyContainer, using: derivedKey)
    }
    
    func unlockWithBiometry() async throws {
        guard let storeIDValue = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        let storeID = StoreID(storeIDValue)
        let masterKeyContainer = try await store.loadMasterKeyContainer(storeID: storeID)
        guard let derivedKeyData = try await keychain.derivedKey else {
            throw Error.derivedKeyMissing
        }
        let derivedKey = DerivedKey(with: derivedKeyData)
        _ = try MasterKey(from: masterKeyContainer, using: derivedKey)
    }
    
    
}

extension LockedService {
    
    enum Error: Swift.Error {
        
        case activeStoreIDMissing
        case derivedKeyMissing
        
    }
    
}
