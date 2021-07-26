import Crypto
import Foundation
import Preferences
import Store

actor SetupService: SetupDependency {
    
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
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws -> MasterKey {
        let storeID = UUID()
        let publicArguments = try DerivedKey.PublicArguments()
        let derivedKeyContainer = publicArguments.container()
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        await defaults.set(activeStoreID: storeID)
        return try await keychain.generateMasterKey(from: masterPassword, publicArguments: publicArguments, with: storeID)
    }
    
}

#if DEBUG
actor SetupServiceStub {}

extension SetupServiceStub: SetupDependency {
    
    var biometryType: BiometryType? {
        get async {
            .faceID
        }
    }
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws -> MasterKey {
        MasterKey()
    }
    
}
#endif
