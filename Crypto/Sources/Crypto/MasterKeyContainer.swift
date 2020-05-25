import CryptoKit
import Foundation

var MasterKeyContainerRandomBytes = RandomBytes
var MasterKeyContainerDerivedKey = DerivedKey
var MasterKeyContainerSeal = AES.GCM.seal as (UnsafeRawBufferPointer, SymmetricKey, AES.GCM.Nonce?) throws -> AES.GCM.SealedBox
var MasterKeyContainerOpen = AES.GCM.open

enum MasterKeyContainerVersion: UInt8, VersionRepresentable {
    
    case version1 = 1
    
}

public enum MasterKeyContainerError: Error {
    
    case invalidDataSize
    case encryptionFailed
    
}

public func MasterKeyContainerEncode(_ masterKey: MasterKey, with password: String) throws -> Data {
    let version = MasterKeyContainerVersion.version1.encoded
    let salt = try MasterKeyContainerRandomBytes(.saltSize)
    let rounds = UnsignedInteger32BitEncode(.keyDerivationRounds)
    let derivedKey = try MasterKeyContainerDerivedKey(salt, .keyDerivationRounds, .keySize, password)
    
    let wrappedCryptoKey = try masterKey.cryptoKey.withUnsafeBytes { cryptoKey in
        let seal = try MasterKeyContainerSeal(cryptoKey, derivedKey, nil)
        return seal.nonce + seal.ciphertext + seal.tag
    } as Data
    
    return version + salt + rounds + wrappedCryptoKey
}

public func MasterKeyContainerDecode(_ container: Data, with password: String) throws -> MasterKey {
    guard container.count >= VersionRepresentableEncodingSize else {
        throw MasterKeyContainerError.invalidDataSize
    }
    
    let versionRange = Range(lowerBound: container.startIndex, count: VersionRepresentableEncodingSize)
    let version = container[versionRange]
    switch try MasterKeyContainerVersion(version) {
    case .version1:
        let payloadIndex = container.startIndex + VersionRepresentableEncodingSize
        let payload = container[payloadIndex...]
        return try MasterKeyContainerDecodeVersion1(payload, with: password)
    }
}

private func MasterKeyContainerDecodeVersion1(_ container: Data, with password: String) throws -> MasterKey {
    guard container.count == .saltSize + UnsignedInteger32BitEncodingSize + .wrappedKeySize else {
        throw MasterKeyContainerError.invalidDataSize
    }
    
    let saltRange = Range(lowerBound: container.startIndex, count: .saltSize)
    let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
    let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
    
    let salt = container[saltRange]
    let rounds = container[roundsRange].map { data in
        return UnsignedInteger32BitDecode(data) as UInt32
    }
    let wrappedKey = container[wrappedKeyRange].map { data in
        return try! AES.GCM.SealedBox(combined: data)
    }
    
    let derivedKey = try MasterKeyContainerDerivedKey(salt, rounds, .keySize, password)
    
    return try MasterKeyContainerOpen(wrappedKey, derivedKey).map { data in
        return MasterKey(data)
    }
}

private extension Int {

    static let saltSize = 32
    static let wrappedKeySize = 60
    static let keySize = 32

}

private extension UInt32 {
    
    static let keyDerivationRounds = Self(524288)
    
}
