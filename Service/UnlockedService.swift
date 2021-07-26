actor UnlockedService: UnlockedDependency {
    
    nonisolated func createItemDependency() -> CreateItemDependency {
        StoreItemEditService()
    }
    
}

#if DEBUG
actor UnlockedServiceStub {}

extension UnlockedServiceStub: UnlockedDependency {
    
    nonisolated func createItemDependency() -> CreateItemDependency {
        StoreItemEditService()
    }
    
}
#endif
