import Foundation

public protocol DataContext {
    
    func bytes(in range: Range<Int>) throws -> Data
    func byte(at index: Int) throws -> Data
    func offset(by delta: Int) -> Self
    
}

public enum DataContextError: Error {
    
    case invalidContext
    case invalidIndex
    case invalidByteRange
    case dataNotAvailable
    
}
