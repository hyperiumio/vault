import CryptoKit
import Foundation
import CommonCrypto

class SymmetricKeyWrapMock {
    
    var passedArguments: Arguments?
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func wrap(_ kek: UnsafeRawPointer, _ kekLen: Int, _ rawKey: UnsafeRawPointer, _ rawKeyLen: Int, _ wrappedKey: UnsafeMutableRawPointer, _ wrappedKeyLen: Int) -> Int32 {
        passedArguments = Arguments(kek: kek, kekLen: kekLen, rawKey: rawKey, rawKeyLen: rawKeyLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
        
        switch configuration {
        case .pass:
            return Int32(kCCSuccess)
        case .failure:
            return Int32(kCCUnspecifiedError)
        case .success(let bytes):
            let wrappedKey = UnsafeMutableRawBufferPointer(start: wrappedKey, count: wrappedKeyLen)
            bytes.copyBytes(to: wrappedKey)
            return Int32(kCCSuccess)
        }
    }
    
}

extension SymmetricKeyWrapMock {
    
    enum Configuration {
        
        case pass
        case failure
        case success(bytes: Data)
        
    }
    
    struct Arguments: Equatable {
        
        let kek: Data
        let rawKey: Data
        
        init(kek: UnsafeRawPointer, kekLen: Int, rawKey: UnsafeRawPointer, rawKeyLen: Int, wrappedKey: UnsafeRawPointer, wrappedKeyLen: Int) {
            self.kek = Data(bytes: kek, count: kekLen)
            self.rawKey = Data(bytes: rawKey, count: rawKeyLen)
        }
        
        init(rawKey: SymmetricKey, kek: SymmetricKey) {
            self.kek = kek.withUnsafeBytes { bytes in
                return Data(bytes)
            }
            self.rawKey = rawKey.withUnsafeBytes { bytes in
                return Data(bytes)
            }
        }
        
    }
    
}
