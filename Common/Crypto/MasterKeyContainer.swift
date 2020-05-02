import CryptoKit
import Foundation

struct MasterKeyContainer {
    
    let salt: Data
    let rounds: Data
    let wrappedKey: Data
    
    init(data: Data) throws {
        guard data.count == .saltSize + .unsignedInteger32BitSize + .wrappedKeySize else {
            throw Error.invalidDataSize
        }
        
        let saltRange = Range(lowerBound: 0, count: .saltSize)
        let roundsRange = Range(lowerBound: saltRange.upperBound, count: .unsignedInteger32BitSize)
        let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
        
        self.salt = data[saltRange]
        self.rounds = data[roundsRange]
        self.wrappedKey = data[wrappedKeyRange]
    }
    
    func decodeMasterKey(using password: String) throws -> SymmetricKey {
        let salt = Salt(data: self.salt)
        guard let rounds = try? UnsignedInteger32BitDecode(data: self.rounds) else {
            throw Error.invalidRounds
        }
        let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .masterKeySize, password: password)
        
        return try KeyCryptor(keyEncryptionKey: derivedKey).unwrap(wrappedKey)
    }
    
}

extension MasterKeyContainer {
    
    static func encodeMasterKey(_ masterKey: SymmetricKey, salt: Salt, rounds: Int, password: String) throws -> Data {
        let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .masterKeySize, password: password)
        
        guard let rounds = try? UnsignedInteger32BitEncode(rounds) else {
            throw Error.invalidRounds
        }
        let wrappedKey = try KeyCryptor(keyEncryptionKey: derivedKey).wrap(masterKey)
        
        return salt.bytes + rounds + wrappedKey
    }
    
}

extension MasterKeyContainer {
    
    enum Error: Swift.Error {
        
        case invalidDataSize
        case invalidRounds
        
    }
    
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let saltSize = 32
    static let wrappedKeySize = 40
    static let masterKeySize = 32

}
