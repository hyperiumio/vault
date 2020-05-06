import CommonCrypto
import CryptoKit

enum DerivedKeyError: Error {
    
    case keyDerivationFailure
    
}

func DerivedKey(salt: [UInt8], rounds: Int, keySize: Int, password: String) throws -> SymmetricKey {
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
    
    let status = CCKeyDerivationPBKDF(.pbkdf2, password, password.count, salt, salt.count, .hmacSha512, rounds, derivedKey.baseAddress, derivedKey.count)
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
