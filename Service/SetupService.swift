import Crypto
import Foundation
import Preferences
import Persistence

protocol SetupServiceProtocol {
    
    var availableBiometry: BiometryType? { get async }
    
    func isPasswordSecure(_ password: String) async -> Bool
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws
    
}


struct SetupService: SetupServiceProtocol {
    
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
    
    func isPasswordSecure(_ password: String) async -> Bool {
        await PasswordIsSecure(password)
    }
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {
        let storeID = UUID()
        let derivedKeyContainer = try CryptorToken.create()
        
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        await defaults.set(activeStoreID: storeID)
        try await cryptor.createMasterKey(from: masterPassword, token: derivedKeyContainer, with: storeID, usingBiometryUnlock: isBiometryEnabled)
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
