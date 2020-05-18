import CryptoKit
import Foundation

public enum MasterKeyContainerError: Error {
    
    case invalidDataSize
    case encryptionFailed
    
}

public func MasterKeyContainerEncode(_ masterKey: MasterKey, with password: String) throws -> Data {
    let version = MasterKeyContainerVersion.version1.encoded
    let salt = try RandomBytes(count: .saltSize)
    let rounds = try UnsignedInteger32BitEncode(.keyDerivationRounds)
    let derivedKey = try DerivedKey(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize, password: password)
    
    let wrappedCryptoKey = try masterKey.cryptoKey.withUnsafeBytes { cryptoKey in
        guard let wrappedCryptoKey = try AES.GCM.seal(cryptoKey, using: derivedKey).combined else {
            throw MasterKeyContainerError.encryptionFailed
        }
        return wrappedCryptoKey
    } as Data
    
    return version + salt + rounds + wrappedCryptoKey

}

public func MasterKeyContainerDecode(_ container: Data, with password: String) throws -> MasterKey {
    guard container.count >= VersionRepresentableByteCount else {
        throw MasterKeyContainerError.invalidDataSize
    }
    
    let version = container[container.startIndex]
    switch try MasterKeyContainerVersion(version) {
    case .version1:
        let payloadIndex = container.startIndex + VersionRepresentableByteCount
        let payload = container[payloadIndex...]
        return try MasterKeyContainerDecodeVersion1(payload, with: password)
    }
}

private func MasterKeyContainerDecodeVersion1(_ container: Data, with password: String) throws -> MasterKey {
    guard container.count == .saltSize + .unsignedInteger32BitSize + .wrappedKeySize else {
        throw MasterKeyContainerError.invalidDataSize
    }
    
    let saltRange = Range(lowerBound: container.startIndex, count: .saltSize)
    let roundsRange = Range(lowerBound: saltRange.upperBound, count: .unsignedInteger32BitSize)
    let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
    
    let salt = container[saltRange].bytes
    let rounds = try container[roundsRange].map { data in
        return try UnsignedInteger32BitDecode(data.bytes)
    }
    let wrappedKey = try container[wrappedKeyRange].map { data in
        return try AES.GCM.SealedBox(combined: data)
    }
    
    let derivedKey = try DerivedKey(salt: salt, rounds: rounds, keySize: .keySize, password: password)
    
    return try AES.GCM.open(wrappedKey, using: derivedKey).map { data in
        return MasterKey(data)
    }
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let saltSize = 32
    static let keyDerivationRounds = 524288
    static let wrappedKeySize = 60
    static let keySize = 32

}
