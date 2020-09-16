import CommonCrypto
import Foundation

var RandomBytesRNG = CCRandomGenerateBytes

func RandomBytes(count: Int) throws -> Data {
    var data = Data(repeating: 0, count: count)
    
    let status = data.withUnsafeMutableBytes { buffer in
        return RandomBytesRNG(buffer.baseAddress, buffer.count)
    }
    guard status == kCCSuccess else {
        throw CryptoError.rngFailure
    }
   
    return data
}
