import Foundation
import Model

struct StoreItemEditService: StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws {
        fatalError()
    }
    
    func delete(itemID: UUID) async throws {
        fatalError()
    }
    
}
