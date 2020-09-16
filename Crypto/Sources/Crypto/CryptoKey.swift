import CryptoKit
import Foundation

var MasterKeyContainerRandomBytes = RandomBytes
var MasterKeyContainerDerivedKey = DerivedKey
var MasterKeyContainerSeal = AES.GCM.seal as (UnsafeRawBufferPointer, SymmetricKey, AES.GCM.Nonce?) throws -> AES.GCM.SealedBox
var MasterKeyContainerOpen = AES.GCM.open

public struct CryptoKey: Equatable {
    
    let value: SymmetricKey
    
    public init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    init<D>(data: D) where D : ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
    public init(from container: Data, using password: String) throws {
        guard container.count == .saltSize + UnsignedInteger32BitEncodingSize + .wrappedKeySize else {
            throw CryptoError.invalidDataSize
        }
        
        let saltRange = Range(lowerBound: container.startIndex, count: .saltSize)
        let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
        let wrappedKeyRange = Range(lowerBound: roundsRange.upperBound, count: .wrappedKeySize)
        
        let salt = container[saltRange]
        
        let roundsData = container[roundsRange]
        let rounds = UnsignedInteger32BitDecode(roundsData) as UInt32
        
        let wrappedKeyData = container[wrappedKeyRange]
        let wrappedKey = try AES.GCM.SealedBox(combined: wrappedKeyData)
        
        let derivedKey = try MasterKeyContainerDerivedKey(salt, rounds, .keySize, password)
        
        let masterKeyData = try MasterKeyContainerOpen(wrappedKey, derivedKey)
        
        self.value = SymmetricKey(data: masterKeyData)
    }
    
    public func encryptedContainer(using password: String) throws -> Data {
        let salt = try MasterKeyContainerRandomBytes(.saltSize)
        let rounds = UnsignedInteger32BitEncode(.keyDerivationRounds)
        let derivedKey = try MasterKeyContainerDerivedKey(salt, .keyDerivationRounds, .keySize, password)
        
        let wrappedCryptoKey = try value.withUnsafeBytes { cryptoKey in
            let seal = try MasterKeyContainerSeal(cryptoKey, derivedKey, nil)
            return seal.nonce + seal.ciphertext + seal.tag
        } as Data
        
        return salt + rounds + wrappedCryptoKey
    }
    
}

extension CryptoKey {
    
    public static func encodeContainer(_ masterKey: CryptoKey, using password: String) throws -> Data {
        let salt = try MasterKeyContainerRandomBytes(.saltSize)
        let rounds = UnsignedInteger32BitEncode(.keyDerivationRounds)
        let derivedKey = try MasterKeyContainerDerivedKey(salt, .keyDerivationRounds, .keySize, password)
        
        let wrappedCryptoKey = try masterKey.value.withUnsafeBytes { cryptoKey in
            let seal = try MasterKeyContainerSeal(cryptoKey, derivedKey, nil)
            return seal.nonce + seal.ciphertext + seal.tag
        } as Data
        
        return salt + rounds + wrappedCryptoKey
    }
    
}

private extension Int {

    static let saltSize = 32
    static let wrappedKeySize = 60
    static let keySize = 32

}

private extension UInt32 {
    
    static let keyDerivationRounds: Self = 524288
    
}
