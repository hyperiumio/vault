import Model

actor StoreItemDetailService: StoreItemDetailDependency {
    
    var storeItem: StoreItem {
        get async throws {
            fatalError()
        }
    }
    
    nonisolated func storeItemEditDependency() -> StoreItemEditDependency {
        fatalError()
    }
    
}

#if DEBUG
import Foundation

actor StoreItemDetailServiceStub {}

extension StoreItemDetailServiceStub: StoreItemDetailDependency {
    
    var storeItem: StoreItem {
        get async throws {
            StoreItemDetailServiceStub.storeItem
        }
    }
    
    nonisolated func storeItemEditDependency() -> StoreItemEditDependency {
        StoreItemEditServiceStub()
    }
    
}

extension StoreItemDetailServiceStub {
    
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
