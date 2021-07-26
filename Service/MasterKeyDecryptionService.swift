import Crypto
import Foundation
import Preferences
import Store

actor MasterKeyDecryptionService {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
    }
    
}

extension MasterKeyDecryptionService: LockedDependency {
    
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
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey? {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        let derivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: storeID)
        let publicArguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
        return try await keychain.loadMasterKey(with: password, publicArguments: publicArguments, id: storeID)
    }
    
    func decryptMasterKeyWithBiometry() async throws -> MasterKey? {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.activeStoreIDMissing
        }
        
        return try await keychain.loadMasterKeyWithBiometry(id: storeID)
    }
    
}

extension MasterKeyDecryptionService {
    
    enum Error: Swift.Error {
        
        case activeStoreIDMissing
        case derivedKeyMissing
        
    }
    
}

#if DEBUG
actor MasterKeyDecryptionServiceStub {}

extension MasterKeyDecryptionServiceStub: LockedDependency {
    
    var biometryType: BiometryType? {
        get async {
            .faceID
        }
    }
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey? {
        MasterKey()
    }
    
    func decryptMasterKeyWithBiometry() async throws -> MasterKey? {
        MasterKey()
    }
    
}
#endif
