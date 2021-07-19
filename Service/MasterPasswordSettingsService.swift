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
    
    func changeMasterPassword(from oldMasterPassword: String, to newMasterPassword: String) async throws {
        guard let oldStoreID = await defaults.activeStoreID else {
            throw MasterPasswordSettingsServiceError.changeMasterPasswordDidFail
        }
        let oldDerivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: oldStoreID)
        let oldPublicArguemnts = try DerivedKey.PublicArguments(from: oldDerivedKeyContainer)
        let oldMasterKey = try await keychain.loadMasterKey(with: oldMasterPassword, publicArguments: oldPublicArguemnts, id: oldStoreID)
        
        let newStoreID = UUID()
        let newPublicArguments = try DerivedKey.PublicArguments()
        let newDerivedKeyContainer = newPublicArguments.container()
        let newMasterKey = try await keychain.generateMasterKey(from: newMasterPassword, publicArguments: newPublicArguments, with: newStoreID)
        try await store.migrateStore(fromStore: oldStoreID, toStore: newStoreID, derivedKeyContainer: newDerivedKeyContainer) { encryptedItem in
            let messages = try SecureDataMessage.decryptMessages(from: encryptedItem, using: oldMasterKey)
            return try SecureDataMessage.encryptContainer(from: messages, using: newMasterKey)
        }
        await defaults.set(activeStoreID: newStoreID)
        
        // delete the old stuff
    }
    
}

enum MasterPasswordSettingsServiceError: Error {
    
    case changeMasterPasswordDidFail
    
}
