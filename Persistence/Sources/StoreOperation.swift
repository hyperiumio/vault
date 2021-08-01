import Foundation

public enum StoreOperation {
    
    case save(itemID: UUID, item: Data)
    case delete(itemID: UUID)
    
}
