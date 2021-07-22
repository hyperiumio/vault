import Crypto
import Foundation
import Preferences
import Store

actor LockedService: LockedDependency {
    
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

extension LockedService {
    
    enum Error: Swift.Error {
        
        case activeStoreIDMissing
        case derivedKeyMissing
        
    }
    
}
