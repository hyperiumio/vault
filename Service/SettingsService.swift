import Crypto
import Foundation
import Persistence
import Preferences

protocol SettingsServiceProtocol {
    
    var availableBiometry: BiometryType? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func save(isBiometricUnlockEnabled: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    
}


struct SettingsService: SettingsServiceProtocol {
    
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
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            await defaults.isBiometricUnlockEnabled
        }
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        await defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        
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
