public enum StoreOperation {
    
    case save(StoreItem, StoreItemLocator?)
    case delete(StoreItemLocator)
    
}
