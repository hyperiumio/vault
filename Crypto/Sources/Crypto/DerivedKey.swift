import CoreCrypto
import CryptoKit
import Foundation

typealias DerivedKeyAllocator = (_ byteCount: Int, _ alignment: Int) -> WritableBuffer
typealias DerivedKeyKDF = (_ password: UnsafeRawPointer, _ passwordLen: Int, _ salt: UnsafeRawPointer, _ saltLen: Int, _ rounds: UInt32, _ derivedKey: UnsafeMutableRawPointer, _ derivedKeyLen: Int) -> Int32

enum DerivedKeyError: Error {
    
    case keyDerivationFailure
    
}

func DerivedKey(salt: Data, rounds: Int, keySize: Int, password: String, allocator: DerivedKeyAllocator = UnsafeMutableRawBufferPointer.allocate, keyDerivation: DerivedKeyKDF = CoreCrypto.DerivedKey) throws -> SymmetricKey {
    
    guard let rounds = UInt32(exactly: rounds) else {
        throw DerivedKeyError.keyDerivationFailure
    }
    
    let derivedKey = allocator(keySize, MemoryLayout<UInt8>.alignment)
    defer {
        for index in derivedKey.indices {
            derivedKey[index] = 0
        }
        derivedKey.deallocate()
    }
    
    let status = salt.withUnsafeBytes { salt in
        return keyDerivation(password, password.count, salt.baseAddress!, salt.count, rounds, derivedKey.baseAddress!, derivedKey.count)
    }
    guard status == CoreCrypto.Success else {
        throw DerivedKeyError.keyDerivationFailure
    }
    
    return SymmetricKey(data: derivedKey.continousBytes)
}
