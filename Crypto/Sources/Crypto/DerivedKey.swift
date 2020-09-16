import CoreCrypto
import CryptoKit
import Foundation

var DerivedKeyKDF = CoreCrypto.DerivedKey

func DerivedKey(salt: Data, rounds: UInt32, keySize: Int, password: String) throws -> SymmetricKey {
    return try ManagedMemory(byteCount: keySize) { derivedKey in
        let status = salt.withUnsafeBytes { salt in
            return DerivedKeyKDF(password, password.count, salt.baseAddress, salt.count, rounds, derivedKey.baseAddress, derivedKey.count)
        }
        guard status == CoreCrypto.Success else {
            throw CryptoError.keyDerivationFailure
        }
        
        return SymmetricKey(data: derivedKey)
    }
}
