import CryptoKit

func DerivedKey(salt: Salt, rounds: Int, keySize: Int, password: String) throws -> SymmetricKey {
    guard let rounds = UInt32(exactly: rounds) else {
        throw DerivedKeyError.invalidRoundValue
    }
    
    return try ManagedBuffer(byteCount: keySize) { buffer in
        try salt.withUnsafeBytes { salt in
            let status = DerivedKey(password, password.count, salt.baseAddress!, salt.count, rounds, buffer.baseAddress!, buffer.count)
            guard status == CryptoSuccess else {
                throw DerivedKeyError.keyDerivationFailure
            }
        }
        
        return SymmetricKey(data: buffer)
    }
}

enum DerivedKeyError: Error {
    
    case invalidRoundValue
    case keyDerivationFailure
    
}
