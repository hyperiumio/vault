import CommonCrypto
import CryptoKit
import Foundation

struct KeyCryptor {
    
    let keyEncryptionKey: SymmetricKey
    
    func wrap(_ key: SymmetricKey, keyWrap: KeyWrap = SymmetricKeyWrap) throws -> Data {
        var bufferSize = key.withUnsafeBytes { key in
            return CCSymmetricWrappedSize(.rfc3394, key.count)
        }
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferSize)
        buffer.initialize(repeating: 0)
        defer {
            buffer.assign(repeating: 0)
            buffer.deinitialize()
            buffer.deallocate()
        }
        
        let status = key.withUnsafeBytes { key in
            return keyEncryptionKey.withUnsafeBytes { keyEncryptionKey in
                return keyWrap(.rfc3394, CCrfc3394_iv, CCrfc3394_ivLen, keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, &bufferSize)
            }
        }
        guard status == kCCSuccess else {
            throw KeyCryptorError.keyWrapFailure
        }
        
        return Data(buffer)
    }
    
    func unwrap(_ wrappedKey: Data, keyUnwrap: KeyUnwrap = SymmetricKeyUnwrap) throws -> SymmetricKey {
        var bufferSize = CCSymmetricUnwrappedSize(.rfc3394, wrappedKey.count)
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferSize)
        buffer.initialize(repeating: 0)
        defer {
            buffer.assign(repeating: 0)
            buffer.deinitialize()
            buffer.deallocate()
        }
        
        let status = wrappedKey.withUnsafeBytes { key in
            return keyEncryptionKey.withUnsafeBytes { keyEncryptionKey in
                return keyUnwrap(.rfc3394, CCrfc3394_iv, CCrfc3394_ivLen, keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, &bufferSize)
            }
        }
        guard status == kCCSuccess else {
            throw KeyCryptorError.keyUnwrapFailure
        }
        
        return SymmetricKey(data: buffer)
    }
    
}

extension KeyCryptor {
    
    typealias KeyWrap = (CCWrappingAlgorithm, UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, UnsafeMutablePointer<Int>) -> Int32
    typealias KeyUnwrap = (CCWrappingAlgorithm, UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, UnsafeMutablePointer<Int>) -> Int32
    
}

enum KeyCryptorError: Error {
    
    case keyWrapFailure
    case keyUnwrapFailure
    
}

private extension CCWrappingAlgorithm {
    
    static let rfc3394 = CCWrappingAlgorithm(kCCWRAPAES)
    
}

private extension UnsafeMutableBufferPointer {
    
    func deinitialize() {
        self.baseAddress?.deinitialize(count: self.count)
    }
    
}
