import CommonCrypto
import Foundation

enum RandomBytesError: Error {
    
    case randomNumberGeneratorFailure
    
}

func RandomBytes(count: Int) throws -> Data {
    let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: MemoryLayout<UInt8>.alignment)
    
    let status = CCRandomGenerateBytes(bytes, count)
    guard status == kCCSuccess else {
        throw RandomBytesError.randomNumberGeneratorFailure
    }
   
    return Data(bytesNoCopy: bytes, count: count, deallocator: .free)
}
