import Foundation

public struct ChangeSet {
    
    public let token: ChangeToken
    public let operations: [ServerOperation]
    
}
