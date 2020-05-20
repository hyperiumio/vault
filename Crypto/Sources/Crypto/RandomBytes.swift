import CommonCrypto
import Foundation

typealias RNG = (UnsafeMutableRawPointer?, Int) -> Int32

enum RandomBytesError: Error {
    
    case randomNumberGeneratorFailure
    
}

func RandomBytes(count: Int, rng: RNG = CCRandomGenerateBytes) throws -> Data {
    let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: MemoryLayout<UInt8>.alignment)
    
    let status = rng(bytes, count)
    guard status == kCCSuccess else {
        throw RandomBytesError.randomNumberGeneratorFailure
    }
   
    return Data(bytesNoCopy: bytes, count: count, deallocator: .free)
}
