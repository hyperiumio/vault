import Foundation

public protocol KeyRepresentable: Equatable {
    
    init()
    init(from container: Data, using password: String) throws
    
    func encryptedContainer(using password: String) throws -> Data
    
}
