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

func RandomNumber(upperBound: Int) throws -> Int {
    var randomValue = UInt8(0)
    repeat {
        let status = RandomBytesRNG(&randomValue, 1)
        guard status == kCCSuccess else {
            throw CryptoError.rngFailure
        }
    } while randomValue >= upperBound

    guard let result = Int(exactly: randomValue) else {
        throw CryptoError.rngFailure
    }
    
    return result
}
