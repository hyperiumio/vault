import CommonCrypto
import CryptoKit
import Foundation

class SymmetricKeyUnwrapMock {
    
    var passedArguments: Arguments?
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func unwrap(_ algorithm: CCWrappingAlgorithm, _ iv: UnsafeRawPointer, _ ivLen: Int, _ kek: UnsafeRawPointer, _ kekLen: Int, _ wrappedKey: UnsafeRawPointer, _ wrappedKeyLen: Int, _ rawKey: UnsafeMutableRawPointer, _ rawKeyLen: UnsafeMutablePointer<Int>) -> Int32 {
        passedArguments = Arguments(algorithm: algorithm, iv: iv, ivLen: ivLen, kek: kek, kekLen: kekLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
        
        switch configuration {
        case .pass:
            return Int32(kCCSuccess)
        case .failure:
            return Int32(kCCUnspecifiedError)
        case .success(let key):
            key.withUnsafeBytes { key in
                let rawKey = UnsafeMutableRawBufferPointer(start: rawKey, count: rawKeyLen.pointee)
                key.copyBytes(to: rawKey)
            }
            return Int32(kCCSuccess)
        }
    }
    
}

extension SymmetricKeyUnwrapMock {
    
    enum Configuration {
        
        case pass
        case failure
        case success(key: SymmetricKey)
        
    }
    
    struct Arguments: Equatable {
        
        let algorithm: CCWrappingAlgorithm
        let iv: Data
        let kek: Data
        let wrappedKey: Data
        
        init(algorithm: CCWrappingAlgorithm, iv: UnsafeRawPointer, ivLen: Int, kek: UnsafeRawPointer, kekLen: Int, wrappedKey: UnsafeRawPointer, wrappedKeyLen: Int) {
            self.algorithm = algorithm
            self.iv = Data(bytes: iv, count: ivLen)
            self.kek = Data(bytes: kek, count: kekLen)
            self.wrappedKey = Data(bytes: wrappedKey, count: wrappedKeyLen)
        }
        
        init(wrappedKey: Data, kek: SymmetricKey) {
            self.algorithm = CCWrappingAlgorithm(kCCWRAPAES)
            self.iv = Data(bytes: CCrfc3394_iv, count: CCrfc3394_ivLen)
            self.kek = kek.withUnsafeBytes { bytes in
                return Data(bytes)
            }
            self.wrappedKey = wrappedKey
        }
        
    }
    
}
