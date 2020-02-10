import Foundation

protocol ByteBuffer {
    
    func bytes(in range: Range<Int>) throws -> Data
    func decodeUnsignedInteger32Bit(in range: Range<Int>) throws -> Int
    
}

enum ByteBufferError: Error {
    
    case bufferOverflow
    case bufferUnderrun
    case invalidContext
    case invalidByteRange
    
}
