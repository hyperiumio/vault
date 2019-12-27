import CryptoKit
import XCTest

class KeyCryptorTestCase: XCTestCase {

    var key: SymmetricKey {
        let keyBytes = "00112233445566778899AABBCCDDEEFF000102030405060708090A0B0C0D0E0F" as Data
        return SymmetricKey(data: keyBytes)
    }
    
    var kek: SymmetricKey {
        let keyBytes = "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F" as Data
        return SymmetricKey(data: keyBytes)
    }
    
    var wrappedKey: Data {
        return "28C9F404C4B810F4CBCCB35CFB87F8263F5786E2D80ED326CBC7F0E71A99F43BFB988B9B7A02DD21"
    }
    
    var cryptor: KeyCryptor {
        return KeyCryptor(keyEncryptionKey: kek)
    }
    
    func testWrapPassedArguments() throws {
        let keyWrapMock = SymmetricKeyWrapMock(configuration: .pass)
        
        _ = try cryptor.wrap(key, keyWrap: keyWrapMock.wrap)

        let expectedArguments = SymmetricKeyWrapMock.Arguments(rawKey: key, kek: kek)
        XCTAssertEqual(keyWrapMock.passedArguments, expectedArguments)
    }
    
    func testWrapSuccess() throws {
        let configuration = SymmetricKeyWrapMock.Configuration.success(bytes: wrappedKey)
        let keyWrapMock = SymmetricKeyWrapMock(configuration: configuration)
        
        let result = try cryptor.wrap(key, keyWrap: keyWrapMock.wrap)
        
        XCTAssertEqual(result, wrappedKey)
    }
    
    func testWrapFailure() {
        let keyWrapMock = SymmetricKeyWrapMock(configuration: .failure)
        
        XCTAssertThrowsError(try cryptor.wrap(key, keyWrap: keyWrapMock.wrap)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyWrapFailure)
        }
    }

    func testUnwrapPassedArguments() throws {
        let keyUnwrapMock = SymmetricKeyUnwrapMock(configuration: .pass)

        _ = try cryptor.unwrap(wrappedKey, keyUnwrap: keyUnwrapMock.unwrap)

        let expectedArguments = SymmetricKeyUnwrapMock.Arguments(wrappedKey: wrappedKey, kek: kek)
        XCTAssertEqual(keyUnwrapMock.passedArguments, expectedArguments)
    }

    func testUnwrapSuccess() throws {
        let configuration = SymmetricKeyUnwrapMock.Configuration.success(key: key)
        let keyUnwrapMock = SymmetricKeyUnwrapMock(configuration: configuration)

        let result = try cryptor.unwrap(wrappedKey, keyUnwrap: keyUnwrapMock.unwrap)

        XCTAssertEqual(result, key)
    }
    
    func testUnwrapFailure() {
        let keyUnwrapMock = SymmetricKeyUnwrapMock(configuration: .failure)

        XCTAssertThrowsError(try cryptor.unwrap(wrappedKey, keyUnwrap: keyUnwrapMock.unwrap)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyUnwrapFailure)
        }
    }
    
}
