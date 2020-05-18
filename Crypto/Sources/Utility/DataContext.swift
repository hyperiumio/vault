public protocol DataContext {
    
    func bytes(in range: Range<Int>) throws -> [UInt8]
    func byte(at index: Int) throws -> UInt8
    func offset(by delta: Int) -> DataContext
    
}

public enum DataContextError: Error {
    
    case invalidContext
    case invalidIndex
    case invalidByteRange
    case dataNotAvailable
    
}
