import Foundation

public enum StoreOperation {
    
    case save(StoreItem, StoreItemLocator?, Encryption)
    case delete(StoreItemLocator)
    
}

public extension StoreOperation {
    
    typealias Encryption = ([Data]) throws -> Data
    
}
