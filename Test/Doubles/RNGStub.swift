import CommonCrypto
import Foundation

func RNGStub(result: CCRNGStatus, bytes: [UInt8]? = nil) -> Salt.RNG {
    return { buffer, count in
        if let bytes = bytes {
            let buffer = UnsafeMutableRawBufferPointer(start: buffer, count: count)
            bytes.copyBytes(to: buffer)
        }
        return result
    }
}
