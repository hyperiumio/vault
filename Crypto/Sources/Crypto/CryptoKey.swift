import CommonCrypto
import CoreCrypto
import CryptoKit
import Foundation

public struct CryptoKey {
    
    let value: SymmetricKey
    
    init(_ value: SymmetricKey) {
        self.value = value
    }
    
    public init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    public init<D>(_ data: D) where D : ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
    public init(fromDerivedKeyContainer container: Data, password: String) throws {
        guard container.count == Self.derivedKeyContainerSize else {
            throw CryptoError.invalidDataSize
        }
        
        let saltRange = Range(lowerBound: container.startIndex, count: .saltSize)
        let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
        
        let salt = container[saltRange]
        let roundsData = container[roundsRange]
        let rounds = UnsignedInteger32BitDecode(roundsData) as UInt32
        
        self.value = try PBKDF2(salt: salt, rounds: rounds, keySize: .keySize, password: password)
    }
    
    public init(fromEncryptedKeyContainer container: Data, using derivedKey: Self) throws {
        let wrappedKey = try AES.GCM.SealedBox(combined: container)
        let masterKeyData = try AES.GCM.open(wrappedKey, using: derivedKey.value)
        
        self.value = SymmetricKey(data: masterKeyData)
    }
    
    public func encryptedKeyContainer(using derivedKey: CryptoKey) throws -> Data {
        try value.withUnsafeBytes { cryptoKey in
            let seal = try AES.GCM.seal(cryptoKey, using: derivedKey.value)
            return seal.nonce + seal.ciphertext + seal.tag
        }
    }
    
}

extension CryptoKey: ContiguousBytes {
    
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try value.withUnsafeBytes(body)
    }
    
}

public extension CryptoKey {
    
    static var derivedKeyContainerSize: Int { .saltSize + UnsignedInteger32BitEncodingSize }
    static var encryptedKeyContainerSize: Int { 60 }
    
    static func derive(from password: String) throws -> (container: Data, key: Self) {
        var salt = Data(repeating: 0, count: .saltSize)
        
        let status = salt.withUnsafeMutableBytes { buffer in
            CCRandomGenerateBytes(buffer.baseAddress, buffer.count)
        }
        guard status == kCCSuccess else {
            throw CryptoError.rngFailure
        }
        
        let container = salt + UnsignedInteger32BitEncode(.keyDerivationRounds)
        let key = try PBKDF2(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize, password: password)
        
        return (container, CryptoKey(key))
    }
    
}

private func PBKDF2(salt: Data, rounds: UInt32, keySize: Int, password: String) throws -> SymmetricKey {
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: keySize, alignment: MemoryLayout<UInt8>.alignment)
    defer {
        for index in buffer.indices {
            buffer[index] = 0
        }
        buffer.deallocate()
    }
    
    let status = salt.withUnsafeBytes { salt in
        CoreCrypto.PBKDF2(password, password.count, salt.baseAddress, salt.count, rounds, buffer.baseAddress, buffer.count)
    }
    guard status == CoreCrypto.Success else {
        throw CryptoError.keyDerivationFailure
    }
    
    return SymmetricKey(data: buffer)
}

private extension Int {

    static let saltSize = 32
    static let keySize = 32

}

private extension UInt32 {
    
    static let keyDerivationRounds: Self = 524288
    
}
