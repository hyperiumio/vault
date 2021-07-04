import Foundation
import Model

struct ProductionStoreItemEditDependency: StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws {
        fatalError()
    }
    
    func delete(itemID: UUID) async throws {
        fatalError()
    }
    
}

#if DEBUG
struct StoreItemEditDependencyStub: StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws {}
    func delete(itemID: UUID) async throws {}
    
    
}
#endif
