import XCTest
@testable import Crypto

class CryptoKeyTests: XCTestCase {
}

/*
class MasterKeyContainerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        MasterKeyContainerRandomBytes = { _ in fatalError() }
        MasterKeyContainerDerivedKey = { _, _, _ ,_ in fatalError() }
        MasterKeyContainerSeal = { _, _, _ in fatalError() }
        MasterKeyContainerOpen = { _, _ in fatalError() }
    }
    
    override func tearDown() {
        MasterKeyContainerRandomBytes = RandomBytes
        MasterKeyContainerDerivedKey = DerivedKey
        MasterKeyContainerSeal = AES.GCM.seal
        MasterKeyContainerOpen = AES.GCM.open
        
        super.tearDown()
    }
    
    func testEncodeSuccess() throws {
        let expectedSalt = Data(0 ..< 32)
        let expectedNonce = Data(32 ..< 44)
        let expectedCiphertext = Data(44 ..< 76)
        let expectedTag = Data(76 ..< 92)
        
        MasterKeyContainerRandomBytes = { _ in expectedSalt }
        MasterKeyContainerDerivedKey = { _, _, _ ,_ in SymmetricKey(size: .bits256) }
        
        MasterKeyContainerSeal = { _, _, _ in
            let expectedNonce = try AES.GCM.Nonce(data: expectedNonce)
            return try AES.GCM.SealedBox(nonce: expectedNonce, ciphertext: expectedCiphertext, tag: expectedTag)
        }
        
        let masterKey = MasterKey()
        let result = try MasterKeyContainerEncode(masterKey, with: "foo")
        
        let versionRange = Range(lowerBound: result.startIndex, count: 1)
        let saltRange = Range(lowerBound: versionRange.upperBound, count: expectedSalt.count)
        let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
        let nonceRange = Range(lowerBound: roundsRange.upperBound, count: expectedNonce.count)
        let ciphertextRange = Range(lowerBound: nonceRange.upperBound, count: expectedCiphertext.count)
        let tagRange = Range(lowerBound: ciphertextRange.upperBound, count: expectedTag.count)
        
        let version = result[versionRange]
        let salt = result[saltRange]
        let rounds = result[roundsRange]
        let nonce = result[nonceRange]
        let ciphertext = result[ciphertextRange]
        let tag = result[tagRange]
        
        XCTAssertEqual(version, "01")
        XCTAssertEqual(salt, expectedSalt)
        XCTAssertEqual("00000800", rounds)
        XCTAssertEqual(nonce, expectedNonce)
        XCTAssertEqual(ciphertext, expectedCiphertext)
        XCTAssertEqual(tag, expectedTag)
    }
    
    func testEncodeRandomBytesArguments() throws {
        MasterKeyContainerRandomBytes = { count in
            XCTAssertEqual(count, 32)
            
            return Data(repeating: 0, count: count)
        }
        
        MasterKeyContainerDerivedKey = { _, _, _, _ in SymmetricKey(size: .bits256) }
        
        MasterKeyContainerSeal = { _, _, _ in
            let combined = Data(repeating: 0, count: 28)
            return try AES.GCM.SealedBox(combined: combined)
        }
        
        let masterKey = MasterKey()
        _ = try MasterKeyContainerEncode(masterKey, with: "")
    }
    
    func testEncodeDerivedKeyArguments() throws {
        let expectedSalt = Data(0 ..< 32)
        let expectedPassword = "foo"
        
        MasterKeyContainerRandomBytes = { _ in expectedSalt }
        
        MasterKeyContainerDerivedKey = { salt, rounds, keySize, password in
            XCTAssertEqual(salt, expectedSalt)
            XCTAssertEqual(rounds, 524288)
            XCTAssertEqual(keySize, 32)
            XCTAssertEqual(password, expectedPassword)
            
            return SymmetricKey(size: .bits256)
        }
        
        MasterKeyContainerSeal = { _, _, _ in
            let combined = Data(repeating: 0, count: 28)
            return try AES.GCM.SealedBox(combined: combined)
        }
        
        let masterKey = MasterKey()
        _ = try MasterKeyContainerEncode(masterKey, with: expectedPassword)
    }
    
    func testEncodeEncryptionArguments() throws {
        let expectedDerivedKey = Data(0 ..< 32)
        let expectedCryptoKey = "FF" as Data
        
        MasterKeyContainerRandomBytes = { _ in Data(repeating: 0, count: 32) }
        MasterKeyContainerDerivedKey = { _, _, _, _ in SymmetricKey(data: expectedDerivedKey) }
        
        MasterKeyContainerSeal = { cryptoKey, derivedKey, nonce in
            let cryptoKey = Data(cryptoKey)
            let derivedKey = derivedKey.withUnsafeBytes { derivedKey in
                return Data(derivedKey)
            }
            
            XCTAssertEqual(cryptoKey, expectedCryptoKey)
            XCTAssertEqual(derivedKey, expectedDerivedKey)
            XCTAssertNil(nonce)
            
            let combined = Data(repeating: 0, count: 28)
            return try AES.GCM.SealedBox(combined: combined)
        }
        
        let masterKey = MasterKey(expectedCryptoKey)
        _ = try MasterKeyContainerEncode(masterKey, with: "")
    }
    
    func testEncodeRandomNumberGeneratorFailure() {
        MasterKeyContainerRandomBytes = { _ in throw RandomBytesError.rngFailure }
        
        let masterKey = MasterKey()
              
        XCTAssertThrowsError(try MasterKeyContainerEncode(masterKey, with: ""))
    }
    
    func testEncodeDerivedKeyFailure() {
        MasterKeyContainerRandomBytes = { _ in Data(repeating: 0, count: 32) }
        MasterKeyContainerDerivedKey = { _, _, _, _ in throw DerivedKeyError.keyDerivationFailure }
        
        let masterKey = MasterKey()
              
        XCTAssertThrowsError(try MasterKeyContainerEncode(masterKey, with: ""))
    }
    
    func testEncodeEncryptionFailure() {
        MasterKeyContainerRandomBytes = { _ in Data(repeating: 0, count: 32) }
        MasterKeyContainerDerivedKey = { _, _, _, _ in SymmetricKey(size: .bits256) }
        MasterKeyContainerSeal = { _, _, _ in throw NSError() }
        
        let masterKey = MasterKey()
              
        XCTAssertThrowsError(try MasterKeyContainerEncode(masterKey, with: ""))
    }
    
    func testDecodeSuccess() throws {
        let data = Data("01") + Data(repeating: 0, count: 96)
        let expectedMasterKey = Data(96 ..< 128)
        
        MasterKeyContainerDerivedKey = { _, _, _, _ in SymmetricKey(size: .bits256) }
        MasterKeyContainerOpen = { _, _ in expectedMasterKey }
        
        let masterKey = try MasterKeyContainerDecode(data, with: "").cryptoKey.withUnsafeBytes { bytes in Data(bytes) }
        
        XCTAssertEqual(masterKey, expectedMasterKey)
    }
    
    func testDecodeIsDataSliceIndependent() throws {
        let version = Data("01")
        let expectedSalt = Data(2 ..< 34)
        let rounds = Data(34 ..< 38)
        let expectedWrappedKey = Data(38 ..< 98)
        let dataChunk = Data("FF") + version + expectedSalt + rounds + expectedWrappedKey
        let containerData = dataChunk[1...]
        
        MasterKeyContainerDerivedKey = { salt, rounds, _, _ in
            XCTAssertEqual(salt, expectedSalt)
            XCTAssertEqual(rounds, 623125282)
            
            return SymmetricKey(size: .bits256)
        }
        
        MasterKeyContainerOpen = { wrappedKey, _ in
            XCTAssertEqual(wrappedKey.combined, expectedWrappedKey)
            
            return Data(repeating: 0, count: 32)
        }
        
        _ = try MasterKeyContainerDecode(containerData, with: "")
    }
    
    func testDecodeVersion1DerivedKeyArguments() throws {
        let expectedPassword = "foo"
        let version = Data("01")
        let expectedSalt = Data(2 ..< 34)
        let rounds = Data(34 ..< 38)
        let wrappedKey = Data(repeating: 0, count: 60)
        let data = version + expectedSalt + rounds + wrappedKey
        
        MasterKeyContainerDerivedKey = { salt, rounds, keySize, password in
            XCTAssertEqual(salt, expectedSalt)
            XCTAssertEqual(rounds, 623125282)
            XCTAssertEqual(keySize, 32)
            XCTAssertEqual(password, expectedPassword)
            
            return SymmetricKey(size: .bits256)
        }
        
        MasterKeyContainerOpen = { _, _ in
            return Data(repeating: 0, count: 32)
        }
        
        _ = try MasterKeyContainerDecode(data, with: expectedPassword)
    }
    
    func testDecodeVersion1DecryptArguments() throws {
        let version = Data("01")
        let salt = Data(repeating: 0, count: 32)
        let rounds = Data(repeating: 0, count: 4)
        let expectedWrappedKey = Data(0 ..< 60)
        let data = version + salt + rounds + expectedWrappedKey
        let expectedDerivedKey = Data(60 ..< 92)
        
        MasterKeyContainerDerivedKey = { _, _, _, _ in
            return SymmetricKey(data: expectedDerivedKey)
        }
        
        MasterKeyContainerOpen = { wrappedKey, derivedKey in
            let derivedKey = derivedKey.withUnsafeBytes { derivedKey in Data(derivedKey) }
            
            XCTAssertEqual(wrappedKey.combined, expectedWrappedKey)
            XCTAssertEqual(derivedKey, expectedDerivedKey)
            
            return Data(repeating: 0, count: 32)
        }
        
        _ = try MasterKeyContainerDecode(data, with: "")
    }
    
    func testDecodeInvalidDataSize() {
        XCTAssertThrowsError(try MasterKeyContainerDecode(.empty, with: ""))
    }
    
    func testDecodeInvalidVersion() {
        XCTAssertThrowsError(try MasterKeyContainerDecode("02", with: ""))
    }
    
    func testDecodeVersion1InvalidDataSize() {
        XCTAssertThrowsError(try MasterKeyContainerDecode("0100", with: ""))
    }
    
    func testDecodeVersion1DerivedKeyFailure() {
        let data = Data("01") + Data(0 ..< 96)
        
        MasterKeyContainerDerivedKey = { _, _, _, _ in throw DerivedKeyError.keyDerivationFailure }
        
        XCTAssertThrowsError(try MasterKeyContainerDecode(data, with: ""))
    }
    
    func testDecodeDecryptionFailure() {
        let data = Data("01") + Data(0 ..< 96)
        
        MasterKeyContainerDerivedKey = { _, _, _, _ in SymmetricKey(size: .bits256) }
        MasterKeyContainerOpen = { _, _ in throw NSError() }
        
        XCTAssertThrowsError(try MasterKeyContainerDecode(data, with: ""))
    }
    
}
*/

/*
class MasterKeyTests: XCTestCase {
    
    func testInit() {
        let masterKey = MasterKey()
        
        XCTAssertEqual(masterKey.cryptoKey.bitCount, 256)
    }
    
    func testInitWithData() {
        let expectedData = Data(0 ..< 32)
        
        let cryptoKeyData = MasterKey(expectedData).cryptoKey.withUnsafeBytes { cryptoKey in
            return Data(cryptoKey)
        }
        
        XCTAssertEqual(cryptoKeyData, expectedData)
    }
    
}
*/


/*
class DerivedKeyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        DerivedKeyKDF = { _, _, _, _, _, _, _ in fatalError() }
    }
    
    override func tearDown() {
        DerivedKeyKDF = CoreCrypto.DerivedKey
        
        super.tearDown()
    }
    
    func testDerivedKeySuccess() throws {
        let expectedKeyData = Data(0 ..< 32)
        
        DerivedKeyKDF = { _, _, _, _, _, buffer, _ in
            expectedKeyData.withUnsafeBytes { expectedKeyData in
                buffer?.copyMemory(from: expectedKeyData.baseAddress!, byteCount: expectedKeyData.count)
            }
            
            return CoreCrypto.Success
        }
        
        let derivedKeyData = try DerivedKey(salt: .empty, rounds: 0, keySize: expectedKeyData.count, password: "").withUnsafeBytes { key in
            return Data(key)
        }
        
        XCTAssertEqual(derivedKeyData, expectedKeyData)
    }
    
    func testKDFArguments() throws {
        let expectedPassword = "foo"
        let expectedPasswordData = Data(expectedPassword.utf8)
        let expectedSalt = Data(0 ..< 32)
        let expectedRounds = UInt32(524288)
        let expectedKeySize = 32
        
        DerivedKeyKDF = { password, passwordSize, salt, saltSize, rounds, derivedKey, derivedKeySize in
            let password = Data(bytes: password!, count: passwordSize)
            let salt = Data(bytes: salt!, count: saltSize)
            
            XCTAssertEqual(password, expectedPasswordData)
            XCTAssertEqual(salt, expectedSalt)
            XCTAssertEqual(rounds, expectedRounds)
            XCTAssertNotNil(derivedKey)
            XCTAssertEqual(derivedKeySize, expectedKeySize)
            
            return CoreCrypto.Success
        }
        
        _ = try DerivedKey(salt: expectedSalt, rounds: expectedRounds, keySize: expectedKeySize, password: expectedPassword)
    }
    
    func testKeyDerivationFailure() {
        DerivedKeyKDF = { _, _, _, _, _, _, _ in -1 }
        
        XCTAssertThrowsError(try DerivedKey(salt: .empty, rounds: 0, keySize: 0, password: ""))
    }
    
}
*/
