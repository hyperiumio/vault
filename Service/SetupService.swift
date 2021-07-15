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
        let publicArguments = try DerivedKey.PublicArguments()
        let derivedKey = try await DerivedKey(from: masterPassword, with: publicArguments)
        let masterKey = MasterKey()
        let derivedKeyContainer = publicArguments.container()
        let masterKeyContainer = try masterKey.encryptedContainer(using: derivedKey)
        let storeID = try await store.createStore(derivedKeyContainer: derivedKeyContainer, masterKeyContainer: masterKeyContainer)
        await defaults.set(activeStoreID: storeID.value)
    }
    
}
