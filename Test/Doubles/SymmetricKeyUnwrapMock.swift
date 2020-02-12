import CryptoKit
import Foundation

class SymmetricKeyUnwrapMock {
    
    var passedArguments: Arguments?
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func unwrap(_ kek: UnsafeRawPointer, _ kekLen: Int, _ wrappedKey: UnsafeRawPointer, _ wrappedKeyLen: Int, _ rawKey: UnsafeMutableRawPointer, _ rawKeyLen: Int) -> Int32 {
        passedArguments = Arguments(kek: kek, kekLen: kekLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
        
        switch configuration {
        case .pass:
            return Int32(CryptoSuccess)
        case .failure:
            return Int32(CryptoFailure)
        case .success(let key):
            key.withUnsafeBytes { key in
                let rawKey = UnsafeMutableRawBufferPointer(start: rawKey, count: rawKeyLen)
                key.copyBytes(to: rawKey)
            }
            return Int32(CryptoSuccess)
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
        
        let kek: Data
        let wrappedKey: Data
        
        init(kek: UnsafeRawPointer, kekLen: Int, wrappedKey: UnsafeRawPointer, wrappedKeyLen: Int) {
            self.kek = Data(bytes: kek, count: kekLen)
            self.wrappedKey = Data(bytes: wrappedKey, count: wrappedKeyLen)
        }
        
        init(wrappedKey: Data, kek: SymmetricKey) {
            self.kek = kek.withUnsafeBytes { bytes in
                return Data(bytes)
            }
            self.wrappedKey = wrappedKey
        }
        
    }
    
}
