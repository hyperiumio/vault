import CommonCrypto
import Foundation

typealias RandomBytesRNG = (_ bytes: UnsafeMutableRawPointer?, _ count: Int) -> Int32
typealias RandomBytesAllocator = (_ byteCount: Int, _ alignment: Int) -> UnsafeMutableRawPointer

enum RandomBytesError: Error {
    
    case randomNumberGeneratorFailure
    
}

func RandomBytes(count: Int, rng: RandomBytesRNG = CCRandomGenerateBytes, allocator: RandomBytesAllocator = UnsafeMutableRawPointer.allocate) throws -> Data {
    let bytes = allocator(count, MemoryLayout<UInt8>.alignment)
    
    let status = rng(bytes, count)
    guard status == kCCSuccess else {
        throw RandomBytesError.randomNumberGeneratorFailure
    }
   
    return Data(bytesNoCopy: bytes, count: count, deallocator: .free)
}
