import Crypto
import Foundation
import Preferences
import Store

struct SetupService: SetupDependency {
    
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
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {
        let storeID = UUID()
        let publicArguments = try DerivedKey.PublicArguments()
        let derivedKeyContainer = publicArguments.container()
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        _ = try await keychain.generateMasterKey(from: masterPassword, publicArguments: publicArguments, with: storeID)
        await defaults.set(activeStoreID: storeID)
    }
    
}
