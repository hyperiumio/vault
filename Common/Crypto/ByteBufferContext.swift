import Foundation

protocol ByteBufferContext {
    
    func bytes(in range: Range<Int>) throws -> Data
    func bytes() throws -> Data
    
}

enum ByteBufferContextError: Error {
    
    case invalidContext
    case invalidByteRange
    case dataNotAvailable
    
}
