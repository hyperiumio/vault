import Foundation
import Model

struct StoreItemEditService: StoreItemEditDependency {
    
    var passwordDependency: PasswordItemDependency {
        PasswordService()
    }
    
    var loginDependency: LoginItemDependency {
        LoginService()
    }
    
    var wifiDependency: WifiItemDependency {
        WifiService()
    }
    
    func save(_ storeItem: StoreItem) async throws {
        fatalError()
    }
    
    func delete(itemID: UUID) async throws {
        fatalError()
    }
    
}
