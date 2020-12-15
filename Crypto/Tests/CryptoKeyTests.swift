import CommonCrypto
import CryptoKit
import XCTest
@testable import Crypto

class CryptoKeyTests: XCTestCase {
    
    func testInit() {
        let key = CryptoKey()
        
        XCTAssertEqual(key.value.bitCount, SymmetricKeySize.bits256.bitCount)
    }
    
    func testInitFromKey() {
        let rawKey = SymmetricKey(size: .bits256)
        let key = CryptoKey(rawKey)
        
        XCTAssertEqual(key.value, rawKey)
    }
    
    func testInitFromData() {
        let keyData = Data(0 ... UInt8.max)
        let rawKey = SymmetricKey(data: keyData)
        let key = CryptoKey(keyData)
        
        XCTAssertEqual(key.value, rawKey)
    }
    
    func testInitFromDerivedKeyContainerSuccess() throws {
        let prefix = [UInt8.max]
        let salt = Array(repeating: 0, count: 32) as [UInt8]
        let rounds = [1, 0, 0, 0]  as [UInt8]
        let container = Data(prefix + salt + rounds)[1...]
        
        let key = try CryptoKey(fromDerivedKeyContainer: container, password: "").withUnsafeBytes { bytes in
            Array(bytes)
        }
        
        let expectedKey = [160, 172, 145, 150, 69, 134, 235, 176, 226, 167, 116, 34, 123, 31, 108, 208, 49, 231, 71, 212, 129, 55, 35, 165, 226, 33, 76, 245, 0, 51, 19, 216] as [UInt8]
        
        XCTAssertEqual(key, expectedKey)
    }
    
    func testInitFromDerivedKeyContainerInvalidContainerSize() {
        let container = Data()
        
        XCTAssertThrowsError(try CryptoKey(fromDerivedKeyContainer: container, password: ""))
    }
    
    func testInitFromDerivedKeyContainerKeyDerivationFailure() {
        let container = Data(repeating: 0, count: 36)
        
        XCTAssertThrowsError(try CryptoKey(fromDerivedKeyContainer: container, password: ""))
    }
    
    func testInitFromEncryptedKeyContainerSuccess() throws {
        let prefix = [0] as [UInt8]
        let containerBytes = [133, 208, 73, 193, 145, 236, 235, 37, 246, 167, 22, 202, 87, 154, 38, 81, 253, 82, 20, 195, 48, 163, 38, 186, 98, 12, 5, 231, 155, 91, 35, 114, 206, 213, 130, 114, 117, 174, 133, 84, 89, 194, 130, 181, 178, 157, 173, 5, 36, 147, 6, 153, 177, 243, 167, 2, 176, 122, 128, 84] as [UInt8]
        let container = Data(prefix + containerBytes)[1...]
        
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = CryptoKey(derivedKeyData)
        
        let masterKey = try CryptoKey(fromEncryptedKeyContainer: container, using: derivedKey).withUnsafeBytes { bytes in
            Array(bytes)
        }
        let expectedKey = Array(repeating: UInt8.max, count: 32)
        
        XCTAssertEqual(masterKey, expectedKey)
    }
    
    func testInitFromEncryptedKeyContainerInvalidContainer() {
        let container = Data()
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = CryptoKey(derivedKeyData)
        
        XCTAssertThrowsError(try CryptoKey(fromEncryptedKeyContainer: container, using: derivedKey))
    }
    
    func testInitFromEncryptedKeyContainerDecryptionFailure() {
        let containerBytes = [133, 208, 73, 193, 145, 236, 235, 37, 246, 167, 22, 202, 87, 154, 38, 81, 253, 82, 20, 195, 48, 163, 38, 186, 98, 12, 5, 231, 155, 91, 35, 114, 206, 213, 130, 114, 117, 174, 133, 84, 89, 194, 130, 181, 178, 157, 173, 5, 36, 147, 6, 153, 177, 243, 167, 2, 176, 122, 128, 84] as [UInt8]
        let container = Data(containerBytes)
        
        let derivedKeyData = Data(repeating: UInt8.max, count: 32)
        let derivedKey = CryptoKey(derivedKeyData)
        
        XCTAssertThrowsError(try CryptoKey(fromEncryptedKeyContainer: container, using: derivedKey))
    }
    
    func testEncryptedKeyContainerSuccess() throws {
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = CryptoKey(derivedKeyData)
        let masterKeyData = Data(repeating: UInt8.max, count: 32)
        let masterKey = CryptoKey(masterKeyData)
        
        let container = try masterKey.encryptedKeyContainer(using: derivedKey)
        
        XCTAssertEqual(container.count, 60)
    }
    
    func testEncryptedKeyContainerEncryptionFailure() {
        let keyData = Data()
        let derivedKey = CryptoKey(keyData)
        let masterKey = CryptoKey(keyData)
        
        XCTAssertThrowsError(try masterKey.encryptedKeyContainer(using: derivedKey))
    }
    
    func testWithUnsafeBytes() {
        let keyData = Data(0 ... UInt8.max)
        let bytes = CryptoKey(keyData).withUnsafeBytes { bytes in
            Data(bytes)
        }
        
        XCTAssertEqual(keyData, bytes)
    }
    
    func testDerivedKeyContainerSize() {
        XCTAssertEqual(CryptoKey.derivedKeyContainerSize, 36)
    }
    
    func testEncryptedKeyContainerSize() {
        XCTAssertEqual(CryptoKey.encryptedKeyContainerSize, 60)
    }
    
    func testDeriveFromPasswordSuccess() throws {
        let derived = try CryptoKey.derive(from: "")
        
        XCTAssertEqual(derived.container.count, 36)
        XCTAssertEqual(derived.key.value.bitCount, SymmetricKeySize.bits256.bitCount)
    }
    
    func testDeriveFromPasswordRNGFailure() {
        let random = { _, _ in
            CCRNGStatus(kCCRNGFailure)
        } as CryptoKey.Configuration.Random
        let configuration = CryptoKey.Configuration.stub(random: random)
        
        XCTAssertThrowsError(try CryptoKey.derive(from: "", configuration: configuration))
    }

    func testDeriveFromPasswordKeyDerivationFailure() {
        let kdf = { _, _, _, _, _, _, _, _, _ in
            Int32(kCCUnimplemented)
        } as CryptoKey.Configuration.KDF
        let configuration = CryptoKey.Configuration.stub(kdf: kdf)
        
        XCTAssertThrowsError(try CryptoKey.derive(from: "", configuration: configuration))
    }
    
}

private extension CryptoKey.Configuration {
    
    static func random(bytes: UnsafeMutableRawPointer?, _ count: Int) -> CCRNGStatus {
        CCRNGStatus(kCCSuccess)
    }
    
    static func kdf(algorithm: CCPBKDFAlgorithm, password: UnsafePointer<Int8>, passwordLen: Int, salt: UnsafePointer<UInt8>, saltLen: Int, prf: CCPseudoRandomAlgorithm, rounds: UInt32, derivedKey: UnsafeMutablePointer<UInt8>, derivedKeyLen: Int) -> Int32 {
        Int32(kCCSuccess)
    }
    
    static func stub(random: @escaping Random = random, kdf: @escaping KDF = kdf) -> Self {
        Self(random: random, kdf: kdf)
    }
    
}
