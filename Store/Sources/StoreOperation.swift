import Foundation

public enum Operation {
    
    case save(itemID: UUID, item: Data)
    case delete(itemID: UUID)
    
}
