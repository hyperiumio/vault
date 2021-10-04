import Foundation

public enum SecureItemStoreOperation {
    
    case save(itemID: UUID, item: Data)
    case delete(itemID: UUID)
    
}
