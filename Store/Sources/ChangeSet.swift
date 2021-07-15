import Foundation

public struct ChangeSet {
    
    public let saved: [ItemID: Data]
    public let deleted: [ItemID]
    
}
