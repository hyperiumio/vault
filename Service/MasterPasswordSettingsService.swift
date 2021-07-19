import Crypto
import Foundation
import Preferences
import Store

actor MasterPasswordSettingsService: MasterPasswordSettingsDependency {
    
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
    
    func changeMasterPassword(to masterPassword: String) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw MasterPasswordSettingsServiceError.changeMasterPasswordDidFail
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

enum MasterPasswordSettingsServiceError: Error {
    
    case changeMasterPasswordDidFail
    
}
