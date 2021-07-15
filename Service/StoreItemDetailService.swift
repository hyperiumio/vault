import Model

struct StoreItemDetailService: StoreItemDetailDependency {
    
    var storeItem: StoreItem {
        get async throws {
            fatalError()
        }
    }
    
    var storeItemEditDependency: StoreItemEditDependency {
        fatalError()
    }
    
}
