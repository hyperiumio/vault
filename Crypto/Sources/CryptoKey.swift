import CommonCrypto
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
    
    public init<D>(_ data: D) where D: ContiguousBytes {
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

extension CryptoKey {
    
    public static var derivedKeyContainerSize: Int { .saltSize + UnsignedInteger32BitEncodingSize }
    public static var encryptedKeyContainerSize: Int { 60 }
    
    public static func derive(from password: String) throws -> (container: Data, key: Self) {
        try derive(from: password, configuration: .production)
    }
    
    static func derive(from password: String, configuration: Configuration) throws -> (container: Data, key: Self) {
        var salt = Data(repeating: 0, count: .saltSize)
        
        let status = salt.withUnsafeMutableBytes { buffer in
            configuration.random(buffer.baseAddress, buffer.count)
        }
        guard status == kCCSuccess else {
            throw CryptoError.rngFailure
        }
        
        let container = salt + UnsignedInteger32BitEncode(.keyDerivationRounds)
        let key = try PBKDF2(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize, password: password, kdf: configuration.kdf)
        
        return (container, CryptoKey(key))
    }
    
}

extension CryptoKey {
    
    public struct Configuration {
        
        typealias Random = (_ bytes: UnsafeMutableRawPointer?, _ count: Int) -> CCRNGStatus
        typealias KDF = (_ algorithm: CCPBKDFAlgorithm, _ password: UnsafePointer<Int8>, _ passwordLen: Int, _ salt: UnsafePointer<UInt8>, _ saltLen: Int, _ prf: CCPseudoRandomAlgorithm, _ rounds: UInt32, _ derivedKey: UnsafeMutablePointer<UInt8>, _ derivedKeyLen: Int) -> Int32
        
        let random: Random
        let kdf: KDF
        
        public static let production = Configuration(random: CCRandomGenerateBytes, kdf: CCKeyDerivationPBKDF)
        
    }
    
}

private func PBKDF2(salt: Data, rounds: UInt32, keySize: Int, password: String, kdf: CryptoKey.Configuration.KDF = CCKeyDerivationPBKDF) throws -> SymmetricKey {
    let salt = Array(salt)
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: keySize)
    buffer.initialize(repeating: 0, count: keySize)
    defer {
        buffer.assign(repeating: 0, count: keySize)
        buffer.deinitialize(count: keySize)
        buffer.deallocate()
    }
    
    let status = kdf(.PBKDF2, password, password.count, salt, salt.count, .PRFHmacAlgSHA512, rounds, buffer, keySize)
    guard status == kCCSuccess else {
        throw CryptoError.keyDerivationFailure
    }
    
    let key = UnsafeBufferPointer(start: buffer, count: keySize)
    return SymmetricKey(data: key)
}

private extension Int {

    static let saltSize = 32
    static let keySize = 32

}

private extension UInt32 {
    
    static let keyDerivationRounds: Self = 524288
    
}

private extension Range where Bound == Int {
    
    init(lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}

private extension CCPBKDFAlgorithm {
    
    static var PBKDF2: Self {
        Self(kCCPBKDF2)
    }
    
}

private extension CCPseudoRandomAlgorithm {
    
    static var PRFHmacAlgSHA512: Self {
        Self(kCCPRFHmacAlgSHA512)
    }
    
}
