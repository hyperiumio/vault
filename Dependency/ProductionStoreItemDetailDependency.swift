import Model

struct ProductionStoreItemDetailDependency: StoreItemDetailDependency {
    
    var storeItem: StoreItem {
        get async throws {
            fatalError()
        }
    }
    
    var storeItemEditDependency: StoreItemEditDependency {
        fatalError()
    }
    
}

#if DEBUG
struct StoreItemDetailDependencyStub: StoreItemDetailDependency {
    
    let storeItem: StoreItem
    let storeItemEditDependency: StoreItemEditDependency
    
}
#endif
