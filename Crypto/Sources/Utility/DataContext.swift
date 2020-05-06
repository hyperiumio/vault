public protocol DataContext {
    
    func bytes(in range: Range<Int>) throws -> [UInt8]
    
}

public enum DataContextError: Error {
    
    case invalidContext
    case invalidByteRange
    case dataNotAvailable
    
}
