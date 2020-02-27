import CryptoKit

struct KeyDerivation {
    
    let salt: Salt
    let rounds: Int
    let keySize: Int
    
    func derive(from password: String) throws -> SymmetricKey {
        guard let rounds = UInt32(exactly: rounds) else {
            throw Error.invalidRoundValue
        }
        
        return try ManagedBuffer(byteCount: keySize) { buffer in
            try salt.withUnsafeBytes { salt in
                let status = DerivedKey(password, password.count, salt.baseAddress!, salt.count, rounds, buffer.baseAddress!, buffer.count)
                guard status == CryptoSuccess else {
                    throw Error.keyDerivationFailure
                }
            }
            
            return SymmetricKey(data: buffer)
        }
    }
    
}

extension KeyDerivation {
    
    enum Error: Swift.Error {
        
        case invalidRoundValue
        case keyDerivationFailure
        
    }
    
}
