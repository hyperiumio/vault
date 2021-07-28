import Crypto
import Foundation
import Store
import Preferences

protocol SettingsServiceProtocol {
    
    var availableBiometry: BiometryType? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func save(isBiometricUnlockEnabled: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    
}


struct SettingsService: SettingsServiceProtocol {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store) {
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
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            await defaults.isBiometricUnlockEnabled
        }
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        await defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        /*
        guard let storeID = await defaults.activeStoreID else {
            throw SettingsServiceError.changeMasterPasswordDidFail
        }
        
        let newStoreID = UUID()
        let newPublicArguments = try DerivedKey.PublicArguments()
        let newDerivedKeyContainer = newPublicArguments.container()
        try await keychain.createMasterKey(from: masterPassword, publicArguments: newPublicArguments, with: newStoreID)
        
        // store migration
        
        await defaults.set(activeStoreID: newStoreID)
         */
    }
    
}

enum SettingsServiceError: Error {
    
    case changeMasterPasswordDidFail
    
}

#if DEBUG
struct SettingsServiceStub: SettingsServiceProtocol {
    
    var availableBiometry: BiometryType? {
        get async {
            .faceID
        }
    }
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            true
        }
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        print(#function)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        print(#function)
    }
    
}
#endif
