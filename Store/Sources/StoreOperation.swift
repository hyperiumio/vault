import Foundation

public enum Operation {
    
    case save(itemID: ItemID, item: Data)
    case delete(itemID: ItemID)
    
}
