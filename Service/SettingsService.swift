import Crypto
import Foundation
import Store
import Preferences

actor SettingsService: SettingsDependency {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    private let masterKeyManager: MasterKeyManager
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store, masterKeyManager: MasterKeyManager) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
        self.masterKeyManager = masterKeyManager
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
    
    nonisolated func biometrySettingsDependency() -> BiometrySettingsDependency {
        BiometrySettingsService(defaults: defaults)
    }
    
    nonisolated func masterPasswordSettingsDependency() -> MasterPasswordSettingsDependency {
        MasterPasswordSettingsService(defaults: defaults, keychain: keychain, store: store, masterKeyManager: masterKeyManager)
    }
    
}
