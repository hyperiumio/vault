import CoreCrypto
import CryptoKit
import Foundation

enum DerivedKeyError: Error {
    
    case keyDerivationFailure
    
}

struct KeyDerivationFunction {
    
    private let allocate: Allocate
    private let deriveKey: DeriveKey
    
    init(allocate: @escaping Allocate = UnsafeMutableRawBufferPointer.allocate, deriveKey: @escaping DeriveKey = CoreCrypto.DerivedKey) {
        self.allocate = allocate
        self.deriveKey = deriveKey
    }
    
    func deriveKey(salt: Data, rounds: Int, keySize: Int, password: String) throws -> SymmetricKey {
        
        guard let rounds = UInt32(exactly: rounds) else {
            throw DerivedKeyError.keyDerivationFailure
        }
        
        let derivedKey = allocate(keySize, MemoryLayout<UInt8>.alignment)
        defer {
            for index in derivedKey.indices {
                derivedKey[index] = 0
            }
            derivedKey.deallocate()
        }
        
        let status = salt.withUnsafeBytes { salt in
            return deriveKey(password, password.count, salt.baseAddress!, salt.count, rounds, derivedKey.baseAddress!, derivedKey.count)
        }
        guard status == CoreCrypto.Success else {
            throw DerivedKeyError.keyDerivationFailure
        }
        
        return SymmetricKey(data: derivedKey.continousBytes)
    }
    
}

extension KeyDerivationFunction {
    
    typealias Allocate = (_ byteCount: Int, _ alignment: Int) -> WritableBuffer
    typealias DeriveKey = (_ password: UnsafeRawPointer, _ passwordLen: Int, _ salt: UnsafeRawPointer, _ saltLen: Int, _ rounds: UInt32, _ derivedKey: UnsafeMutableRawPointer, _ derivedKeyLen: Int) -> Int32
    
}
