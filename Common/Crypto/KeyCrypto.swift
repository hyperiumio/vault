import CryptoKit
import Foundation

typealias KeyWrap = (UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, Int) -> Int32
typealias KeyUnwrap = (UnsafeRawPointer, Int, UnsafeRawPointer, Int, UnsafeMutableRawPointer, Int) -> Int32

enum KeyCryptorError: Error {
    
    case keyWrapFailure
    case keyUnwrapFailure
    
}

func KeyEncrypt(keyEncryptionKey: SymmetricKey, key: SymmetricKey, keyWrap: KeyWrap = SymmetricKeyWrap) throws -> Data {
    let wrappedKeySize = key.withUnsafeBytes { key in
        return SymmetricWrappedSize(key.count)
    }
    
    return try ManagedBuffer(byteCount: wrappedKeySize) { buffer in
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

func KeyDecrypt(keyEncryptionKey: SymmetricKey, wrappedKey: Data, keyUnwrap: KeyUnwrap = SymmetricKeyUnwrap) throws -> SymmetricKey {
    let unwrappedKeySize = SymmetricUnwrappedSize(wrappedKey.count)
    
    return try ManagedBuffer(byteCount: unwrappedKeySize) { buffer in
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