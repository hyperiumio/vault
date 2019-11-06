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
        
        CCSymmetricKeyWrapConfiguration.current = nil
        CCSymmetricKeyWrapArguments.current = nil
    }
    
    override func tearDown() {
        super.tearDown()
        
        CCSymmetricKeyWrapConfiguration.current = nil
        CCSymmetricKeyWrapArguments.current = nil
    }
    
    func testWrapPassedArguments() throws {
        CCSymmetricKeyWrapConfiguration.current = .pass
        
        _ = try cryptor.wrap(key)

        let expectedArguments = CCSymmetricKeyWrapArguments(rawKey: key, kek: kek)
        XCTAssertEqual(CCSymmetricKeyWrapArguments.current, expectedArguments)
    }
    
    func testWrapSuccess() throws {
        CCSymmetricKeyWrapConfiguration.current = .success(bytes: wrappedKey)
        
        let result = try cryptor.wrap(key)
        
        XCTAssertEqual(result, wrappedKey)
    }
    
    func testWrapFailure() {
        CCSymmetricKeyWrapConfiguration.current = .failure
        
        XCTAssertThrowsError(try cryptor.wrap(key)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyWrapFailure)
        }
    }

    func testUnwrapPassedArguments() throws {
        CCSymmetricKeyUnwrapConfiguration.current = .pass

        _ = try cryptor.unwrap(wrappedKey)

        let expectedArguments = CCSymmetricKeyUnwrapArguments(wrappedKey: wrappedKey, kek: kek)
        XCTAssertEqual(CCSymmetricKeyUnwrapArguments.current, expectedArguments)
    }

    func testUnwrapSuccess() throws {
        CCSymmetricKeyUnwrapConfiguration.current = .success(key: key)

        let result = try cryptor.unwrap(wrappedKey)

        XCTAssertEqual(result, key)
    }
    
    func testUnwrapFailure() {
        CCSymmetricKeyUnwrapConfiguration.current = .failure

        XCTAssertThrowsError(try cryptor.unwrap(wrappedKey)) { error in
            XCTAssertEqual(error as? KeyCryptorError, KeyCryptorError.keyUnwrapFailure)
        }
    }
    
}
