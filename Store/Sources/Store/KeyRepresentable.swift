import Foundation

public protocol KeyRepresentable: Equatable {
    
    init(from container: Data, using password: String) throws
    
}
