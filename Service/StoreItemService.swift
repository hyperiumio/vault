import Crypto
import Foundation
import Model
import Preferences
import Store

protocol StoreItemServiceProtocol {
    
    func load(itemID: UUID) async throws -> StoreItem
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    
}


struct StoreItemService: StoreItemServiceProtocol {
    
    private let defaults: Defaults<UserDefaults>
    private let keychain: Keychain
    private let store: Store
    
    init(defaults: Defaults<UserDefaults>, keychain: Keychain, store: Store) {
        self.defaults = defaults
        self.keychain = keychain
        self.store = store
    }
    
    func load(itemID: UUID) async throws -> StoreItem {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let encryptedMessages = try await store.loadItem(storeID: storeID, itemID: itemID)
        let decryptedMessages = try await keychain.decryptMessages(from: encryptedMessages)
        
        guard let encodedInfo = decryptedMessages.first else {
            throw Error.invalidMessageContainer
        }
        let encodedItems = decryptedMessages.dropFirst()
        guard let encodedPrimaryItem = encodedItems.first else {
            throw Error.invalidMessageContainer
        }
        let encodedSecondaryItems = encodedItems.dropFirst()
                    
        let info = try StoreItemInfo(from: encodedInfo)
        guard encodedSecondaryItems.count == info.secondaryTypes.count else {
            throw Error.invalidMessageContainer
        }
                    
        let primaryItem = try SecureItem(from: encodedPrimaryItem, as: info.primaryType)
        let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
            try SecureItem(from: encodedItem, as: itemType)
        }
                    
        return StoreItem(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
        
    }
    
    func save(_ storeItem: StoreItem) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let encryptedStoreItem = Data()
        let operations = [
            Operation.save(itemID: storeItem.id, item: encryptedStoreItem)
        ]
        try await store.commit(storeID: storeID, operations: operations)
    }
    
    func delete(itemID: UUID) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let operations = [
            Operation.delete(itemID: itemID)
        ]
        try await store.commit(storeID: storeID, operations: operations)
    }
    
}

extension StoreItemService {
    
    enum Error: Swift.Error {
        
        case noActiveStoreID
        case invalidMessageContainer
        
    }
    
}

#if DEBUG
import Foundation

struct StoreItemServiceStub: StoreItemServiceProtocol {
    
    func load(itemID: UUID) async throws -> StoreItem {
        Self.storeItem
    }
    
    func save(_ storeItem: StoreItem) async throws {
        print(#function)
    }
    
    func delete(itemID: UUID) async throws {
        print(#function)
    }
    
}

extension StoreItemServiceStub {
    
    static var storeItem: StoreItem {
        let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
        let passwordItem = PasswordItem(password: "qux")
        let id = UUID()
        let primaryItem = SecureItem.login(loginItem)
        let secondaryItems = [
            SecureItem.password(passwordItem)
        ]
        return StoreItem(id: id, name: "quux", primaryItem: primaryItem, secondaryItems: secondaryItems, created: .now, modified: .now)
    }
    
}
#endif
