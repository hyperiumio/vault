import CommonCryptoShim
import CryptoKit
import Foundation

enum DerivedKeyError: Error {
    
    case keyDerivationFailure
    
}

func DerivedKey(salt: Data, rounds: Int, keySize: Int, password: String) throws -> SymmetricKey {
    guard let rounds = UInt32(exactly: rounds) else {
        throw DerivedKeyError.keyDerivationFailure
    }
    
    let derivedKey = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: keySize)
    derivedKey.initialize(repeating: 0)
    defer {
        derivedKey.assign(repeating: 0)
        derivedKey.baseAddress?.deinitialize(count: derivedKey.count)
        derivedKey.deallocate()
    }
    
    let status = salt.withUnsafeBytes { salt  in
        return shim_CCKeyDerivationPBKDF(.pbkdf2, password, password.count, salt.baseAddress, salt.count, .hmacSha512, rounds, derivedKey.baseAddress, derivedKey.count)
    }
    guard status == kCCSuccess else {
        throw DerivedKeyError.keyDerivationFailure
    }
    
    return SymmetricKey(data: derivedKey)
}

private extension CCPBKDFAlgorithm {
    
    static let pbkdf2 = Self(kCCPBKDF2)
    
}

private extension CCPseudoRandomAlgorithm {
    
    static let hmacSha512 = Self(kCCPRFHmacAlgSHA512)
    
}
