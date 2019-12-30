import CommonCrypto
import CryptoKit
import Foundation

struct KeyCryptor {
    
    let keyEncryptionKey: SymmetricKey
    
    func wrap(_ key: SymmetricKey, keyWrap: KeyWrap = SymmetricKeyWrap) throws -> Data {
        let bufferSize = key.withUnsafeBytes { key in
            return SymmetricWrappedSize(key.count)
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
                return keyWrap(keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, bufferSize)
            }
        }
        guard status == kCCSuccess else {
            throw KeyCryptorError.keyWrapFailure
        }
        
        return Data(buffer)
    }
    
    func unwrap(_ wrappedKey: Data, keyUnwrap: KeyUnwrap = SymmetricKeyUnwrap) throws -> SymmetricKey {
        let bufferSize = SymmetricUnwrappedSize(wrappedKey.count)
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferSize)
        buffer.initialize(repeating: 0)
        defer {
            buffer.assign(repeating: 0)
            buffer.deinitialize()
            buffer.deallocate()
        }
        
        let status = wrappedKey.withUnsafeBytes { key in
            return keyEncryptionKey.withUnsafeBytes { keyEncryptionKey in
                return keyUnwrap(keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, bufferSize)
            }
        }
        guard status == kCCSuccess else {
            throw KeyCryptorError.keyUnwrapFailure
        }
        
        return SymmetricKey(data: buffer)
    }
    
}

extension KeyCryptor {
    
    typealias KeyWrap = (UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, Int) -> Int32
    typealias KeyUnwrap = (UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, Int) -> Int32
    
}

enum KeyCryptorError: Error {
    
    case keyWrapFailure
    case keyUnwrapFailure
    
}

private extension UnsafeMutableBufferPointer {
    
    func deinitialize() {
        self.baseAddress?.deinitialize(count: self.count)
    }
    
}
