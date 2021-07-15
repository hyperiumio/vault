import Crypto
import Foundation
import Preferences
import Store

struct MasterPasswordSettingsService: MasterPasswordSettingsDependency {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
    }
    
    func changeMasterPassword(to newMasterPassword: String) async throws {
        guard
            let storeIDValue = await defaults.activeStoreID,
            let masterKeyData = try await keychain.loadSecret(forKey: .masterKey)
        else {
            throw MasterPasswordSettingsServiceError.changeMasterPasswordDidFail
        }
        let storeID = StoreID(storeIDValue)
        let masterKey = MasterKey(with: masterKeyData)
        
        let newPublicArguments = try DerivedKey.PublicArguments()
        let newDerivedKey = try await DerivedKey(from: newMasterPassword, with: newPublicArguments)
        let newMasterKey = MasterKey()
        let newDerivedKeyContainer = newPublicArguments.container()
        let newMasterKeyContainer = try masterKey.encryptedContainer(using: newDerivedKey)
        let newStoreID = try await store.migrateStore(fromStore: storeID, derivedKeyContainer: newDerivedKeyContainer, masterKeyContainer: newMasterKeyContainer) { encryptedItem in
            let messages = try SecureDataMessage.decryptMessages(from: encryptedItem, using: masterKey)
            return try SecureDataMessage.encryptContainer(from: messages, using: newMasterKey)
        }
        
          await defaults.set(activeStoreID: newStoreID.value)
        try await keychain.storeSecret(newDerivedKey, forKey: .derivedKey)
        try await keychain.storeSecret(newMasterKey, forKey: .masterKey)
    }
    
}

enum MasterPasswordSettingsServiceError: Error {
    
    case changeMasterPasswordDidFail
    
}

private extension String {
    
    static var derivedKey: String { "DerivedKey" }
    static var masterKey: String { "MasterKey" }
    
}
