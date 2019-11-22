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
    
    override func setUp() {
        super.setUp()
        
        SymmetricKeyWrapConfiguration.current = nil
        SymmetricKeyWrapArguments.current = nil
    }
    
    override func tearDown() {
        super.tearDown()
        
        SymmetricKeyWrapConfiguration.current = nil
        SymmetricKeyWrapArguments.current = nil
    }
    
    func testWrapPassedArguments() throws {
        SymmetricKeyWrapConfiguration.current = .pass
        
        _ = try cryptor.wrap(key)

        let expectedArguments = SymmetricKeyWrapArguments(rawKey: key, kek: kek)
        XCTAssertEqual(SymmetricKeyWrapArguments.current, expectedArguments)
    }
    
    func testWrapSuccess() throws {
        SymmetricKeyWrapConfiguration.current = .success(bytes: wrappedKey)
        
        let result = try cryptor.wrap(key)
        
        XCTAssertEqual(result, wrappedKey)
    }
    
    func testWrapFailure() {
        SymmetricKeyWrapConfiguration.current = .failure
        
        XCTAssertThrowsError(try cryptor.wrap(key)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyWrapFailure)
        }
    }

    func testUnwrapPassedArguments() throws {
        SymmetricKeyUnwrapConfiguration.current = .pass

        _ = try cryptor.unwrap(wrappedKey)

        let expectedArguments = SymmetricKeyUnwrapArguments(wrappedKey: wrappedKey, kek: kek)
        XCTAssertEqual(SymmetricKeyUnwrapArguments.current, expectedArguments)
    }

    func testUnwrapSuccess() throws {
        SymmetricKeyUnwrapConfiguration.current = .success(key: key)

        let result = try cryptor.unwrap(wrappedKey)

        XCTAssertEqual(result, key)
    }
    
    func testUnwrapFailure() {
        SymmetricKeyUnwrapConfiguration.current = .failure

        XCTAssertThrowsError(try cryptor.unwrap(wrappedKey)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyUnwrapFailure)
        }
    }
    
}
