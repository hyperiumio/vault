import CommonCrypto
import CryptoKit

struct KeyDerivation {
    
    let salt: Salt
    let rounds: Int
    
    func derive(from password: String) throws -> SymmetricKey {
        guard let rounds = UInt32(exactly: rounds) else {
            throw Error.invalidRoundValue
        }
        
        let derivedKeySize = 32
        return try UnsafeMutableRawBufferPointer.managedByteContext(byteCount: derivedKeySize) { buffer in
            try salt.withUnsafeBytes { salt in
                let status = KeyDerivationn(password, password.count, salt.baseAddress!, salt.count, rounds, buffer.baseAddress!, buffer.count)
                guard status == kCCSuccess else {
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
