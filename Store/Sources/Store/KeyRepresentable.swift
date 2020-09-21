import Foundation

public protocol KeyRepresentable {
    
    init(from container: Data, using password: String) throws
    
}
