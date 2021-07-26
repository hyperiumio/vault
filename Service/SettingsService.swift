import Crypto
import Foundation
import Store
import Preferences

actor SettingsService {
    
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
    
}

extension SettingsService: SettingsDependency {
    
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
        self
    }
    
    nonisolated func masterPasswordSettingsDependency() -> MasterPasswordSettingsDependency {
        self
    }
    
}

extension SettingsService: BiometrySettingsDependency {
    
    func save(isBiometricUnlockEnabled: Bool) async {
        await defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
    }
    
}

extension SettingsService: MasterPasswordSettingsDependency {
    
    func changeMasterPassword(to masterPassword: String) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw SettingsServiceError.changeMasterPasswordDidFail
        }
        let masterKey = await masterKeyManager.masterKey
        
        let newStoreID = UUID()
        let newPublicArguments = try DerivedKey.PublicArguments()
        let newDerivedKeyContainer = newPublicArguments.container()
        let newMasterKey = try await keychain.generateMasterKey(from: masterPassword, publicArguments: newPublicArguments, with: newStoreID)
        try await store.migrateStore(fromStore: storeID, toStore: newStoreID, derivedKeyContainer: newDerivedKeyContainer) { encryptedItem in
            let messages = try SecureDataMessage.decryptMessages(from: encryptedItem, using: masterKey)
            return try SecureDataMessage.encryptContainer(from: messages, using: newMasterKey)
        }
        await defaults.set(activeStoreID: newStoreID)
        await masterKeyManager.setMasterKey(newMasterKey)
        
        // delete the old stuff
    }
    
}

enum SettingsServiceError: Error {
    
    case changeMasterPasswordDidFail
    
}

#if DEBUG
actor SettingsServiceStub {}

extension SettingsServiceStub: SettingsDependency {
    
    var biometryType: BiometryType? {
        get async {
            .faceID
        }
    }
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            true
        }
    }
    
    nonisolated func biometrySettingsDependency() -> BiometrySettingsDependency {
        self
    }
    
    nonisolated func masterPasswordSettingsDependency() -> MasterPasswordSettingsDependency {
        self
    }
    
}

extension SettingsServiceStub: BiometrySettingsDependency {
    
    func save(isBiometricUnlockEnabled: Bool) async {}
    
}

extension SettingsServiceStub: MasterPasswordSettingsDependency {
    
    func changeMasterPassword(to masterPassword: String) async throws {}
    
}
#endif
