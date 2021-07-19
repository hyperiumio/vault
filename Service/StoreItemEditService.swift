import Foundation
import Model

actor StoreItemEditService: StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws {
        fatalError()
    }
    
    func delete(itemID: UUID) async throws {
        fatalError()
    }
    
    nonisolated func passwordDependency() -> PasswordItemDependency {
        PasswordService()
    }
    
    nonisolated func loginDependency() -> LoginItemDependency {
        LoginService()
    }
    
    nonisolated func wifiDependency() -> WifiItemDependency {
        WifiService()
    }
    
}
