import CryptoKit
import Foundation

enum MasterKeyError: Swift.Error {
    
    case invalidDataSize
    case invalidRounds
    
}

func MasterKeyContainerEncrypt(masterKey: SymmetricKey, salt: Salt, rounds: Int, password: String) throws -> Data {
    guard let encodedRounds = try? UnsignedInteger32BitEncode(rounds) else {
        throw MasterKeyError.invalidRounds
    }
    
    let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .masterKeySize, password: password)
    let wrappedKey = try KeyEncrypt(keyEncryptionKey: derivedKey, key: masterKey)
    
    return salt.bytes + encodedRounds + wrappedKey
}

func MasterKeyContainerDecrypt(masterKeyContainer: Data, password: String) throws -> SymmetricKey {
    guard masterKeyContainer.count == .saltSize + .unsignedInteger32BitSize + .wrappedKeySize else {
        throw MasterKeyError.invalidDataSize
    }
    
    let saltRange = Range(lowerBound: 0, count: .saltSize)
    let roundsRange = Range(lowerBound: saltRange.upperBound, count: .unsignedInteger32BitSize)
    let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
    
    let salt = masterKeyContainer[saltRange].map { data in
        return Salt(data: data)
    }
    let rounds = try masterKeyContainer[roundsRange].map { data in
        return try UnsignedInteger32BitDecode(data: data)
    }
    let wrappedKey = masterKeyContainer[wrappedKeyRange]
    let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .masterKeySize, password: password)
    
    return try KeyDecrypt(keyEncryptionKey: derivedKey, wrappedKey: wrappedKey)
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let saltSize = 32
    static let wrappedKeySize = 40
    static let masterKeySize = 32

}
