import Foundation

public struct ChangeSet {
    
    public let saved: [UUID: Data]
    public let deleted: [UUID]
    
}
