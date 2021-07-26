import Foundation
import Model

actor StoreItemEditService: StoreItemEditDependency, CreateItemDependency {
    
    func save(_ storeItem: StoreItem) async throws {
        print(#function)
    }
    
    func delete(itemID: UUID) async throws {
        print(#function)
    }
    
    nonisolated func secureItemDependency() -> SecureItemDependency {
        SecureItemService()
    }
    
}

#if DEBUG
actor StoreItemEditServiceStub {}

extension StoreItemEditServiceStub: StoreItemEditDependency, CreateItemDependency {
    
    func save(_ storeItem: StoreItem) async throws {
        print(#function)
    }
    
    func delete(itemID: UUID) async throws {
        print(#function)
    }
    
    nonisolated func secureItemDependency() -> SecureItemDependency {
        SecureItemService()
    }
    
}

extension StoreItemEditServiceStub {
    
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
