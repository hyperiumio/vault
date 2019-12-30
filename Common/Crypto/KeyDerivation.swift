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
        let derivedKey = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: derivedKeySize)
        derivedKey.initialize(repeating: 0)
        defer {
            derivedKey.assign(repeating: 0)
            derivedKey.deinitialize()
            derivedKey.deallocate()
        }
        
        let status = salt.withUnsafeBytes { salt in
            return KeyDerivationn(password, password.count, salt.baseAddress!, salt.count, rounds, derivedKey.baseAddress!, derivedKey.count)
        }
        guard status == kCCSuccess else {
            throw Error.keyDerivationFailure
        }
        
        return SymmetricKey(data: derivedKey)
    }
    
}

extension KeyDerivation {
    
    enum Error: Swift.Error {
        
        case invalidRoundValue
        case keyDerivationFailure
        
    }

    
}
