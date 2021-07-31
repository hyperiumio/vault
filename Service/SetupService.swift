import Crypto
import Foundation
import Preferences
import Store

protocol SetupServiceProtocol {
    
    var availableBiometry: BiometryType? { get async }
    
    func isPasswordSecure(_ password: String) async -> Bool
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws
    
}


struct SetupService: SetupServiceProtocol {
    
    private let defaults: Defaults
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults, keychain: Keychain, store: Store) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
    }
    
    var availableBiometry: BiometryType? {
        get async {
            switch await keychain.availability {
            case .notAvailable, .notEnrolled:
                return nil
            case .enrolled(.touchID):
                return .touchID
            case .enrolled(.faceID):
                return .faceID
            }
        }
    }
    
    func isPasswordSecure(_ password: String) async -> Bool {
        await PasswordIsSecure(password)
    }
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {
        let storeID = UUID()
        let publicArguments = try DerivedKey.PublicArguments()
        let derivedKeyContainer = publicArguments.container()
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        await defaults.set(activeStoreID: storeID)
        try await keychain.createMasterKey(from: masterPassword, publicArguments: publicArguments, with: storeID)
    }
    
}

#if DEBUG
struct SetupServiceStub: SetupServiceProtocol {
    
    var availableBiometry: BiometryType? {
        get async {
            .faceID
        }
    }
    
    func isPasswordSecure(_ password: String) async -> Bool {
        true
    }
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {
        print(#function)
    }
    
}
#endif
