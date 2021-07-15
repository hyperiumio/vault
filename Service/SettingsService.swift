import Crypto
import Foundation
import Store
import Preferences

struct SettingsService: SettingsDependency {
    
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
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            await defaults.isBiometricUnlockEnabled
        }
    }
    
    var biometrySettingsDependency: BiometrySettingsDependency {
        BiometrySettingsService(defaults: defaults)
    }
    
    var masterPasswordSettingsDependency: MasterPasswordSettingsDependency {
        MasterPasswordSettingsService(defaults: defaults, keychain: keychain, store: store)
    }
    
}
