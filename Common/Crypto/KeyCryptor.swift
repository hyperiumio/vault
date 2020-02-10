import CryptoKit
import Foundation

struct KeyCryptor {
    
    let keyEncryptionKey: SymmetricKey
    
    func wrap(_ key: SymmetricKey, keyWrap: KeyWrap = SymmetricKeyWrap) throws -> Data {
        let wrappedKeySize = key.withUnsafeBytes { key in
            return SymmetricWrappedSize(key.count)
        }
        return try UnsafeMutableRawBufferPointer.managedByteContext(byteCount: wrappedKeySize) { buffer in
            try key.withUnsafeBytes { key in
                try keyEncryptionKey.withUnsafeBytes { keyEncryptionKey in
                    let status = keyWrap(keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, buffer.count)
                    guard status == CryptoSuccess else {
                        throw KeyCryptorError.keyWrapFailure
                    }
                }
            }
            
            return Data(buffer)
        }
    }
    
    func unwrap(_ wrappedKey: Data, keyUnwrap: KeyUnwrap = SymmetricKeyUnwrap) throws -> SymmetricKey {
        let unwrappedKeySize = SymmetricUnwrappedSize(wrappedKey.count)
        return try UnsafeMutableRawBufferPointer.managedByteContext(byteCount: unwrappedKeySize) { buffer in
            try wrappedKey.withUnsafeBytes { key in
                try keyEncryptionKey.withUnsafeBytes { keyEncryptionKey in
                    let status = keyUnwrap(keyEncryptionKey.baseAddress!, keyEncryptionKey.count, key.baseAddress!, key.count, buffer.baseAddress!, buffer.count)
                    guard status == CryptoSuccess else {
                        throw KeyCryptorError.keyUnwrapFailure
                    }
                }
            }
            
            return SymmetricKey(data: buffer)
        }
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
