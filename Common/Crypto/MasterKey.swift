import CryptoKit
import Foundation

enum MasterKeyError: Swift.Error {
    
    case invalidDataSize
    case invalidRounds
    
}

func MasterKeyEncrypt(password: String) throws -> Data {
    let salt = try Salt(size: .saltSize)
    let encodedRounds = try UnsignedInteger32BitEncode(.keyDerivationRounds)
    let derivedKey = try DerivedKey(salt: salt, rounds: .keyDerivationRounds, keySize: .masterKeySize, password: password)
    let masterKey = SymmetricKey(size: .bits256)
    let wrappedKey = try KeyEncrypt(keyEncryptionKey: derivedKey, key: masterKey)
    
    return salt.bytes + encodedRounds + wrappedKey
}

func MasterKeyDecrypt(encryptedMasterKey: Data, password: String) throws -> SymmetricKey {
    guard encryptedMasterKey.count == .saltSize + .unsignedInteger32BitSize + .wrappedKeySize else {
        throw MasterKeyError.invalidDataSize
    }
    
    let saltRange = Range(lowerBound: 0, count: .saltSize)
    let roundsRange = Range(lowerBound: saltRange.upperBound, count: .unsignedInteger32BitSize)
    let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
    
    let salt = encryptedMasterKey[saltRange].map { data in
        return Salt(data: data)
    }
    let rounds = try encryptedMasterKey[roundsRange].map { data in
        return try UnsignedInteger32BitDecode(data: data)
    }
    let wrappedKey = encryptedMasterKey[wrappedKeyRange]
    let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .masterKeySize, password: password)
    
    return try KeyDecrypt(keyEncryptionKey: derivedKey, wrappedKey: wrappedKey)
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let saltSize = 32
    static let wrappedKeySize = 40
    static let masterKeySize = 32
    static let keyDerivationRounds = 524288
    static let keySize = 32

}
