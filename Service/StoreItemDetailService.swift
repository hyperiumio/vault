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
