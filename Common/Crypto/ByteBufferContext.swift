import Foundation

protocol ByteBufferContext {
    
    func bytes(in range: Range<Int>) throws -> Data
    func decodeUnsignedInteger32Bit(in range: Range<Int>) throws -> Int
    
}

enum ByteBufferContextError: Error {
    
    case bufferOverflow
    case bufferUnderrun
    case invalidContext
    case invalidByteRange
    
}
