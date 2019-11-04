import CryptoKit
import XCTest

class AESKeyWrapTestCase: XCTestCase {

    let key = SymmetricKey(data: "00112233445566778899AABBCCDDEEFF000102030405060708090A0B0C0D0E0F" as Data)
    let kek = SymmetricKey(data: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F" as Data)
    let wrappedKey = "28C9F404C4B810F4CBCCB35CFB87F8263F5786E2D80ED326CBC7F0E71A99F43BFB988B9B7A02DD21" as Data

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
    
    func testWrappedKeySize256Bit() {
        let wrappedKeySize = AESKeyWrappedSize(unwrappedSize: 32)

        XCTAssertEqual(wrappedKeySize, 40)
    }

    func testUnwrappedKeySize256Bit() {
        let wrappedKeySize = AESKeyUnwrappedSize(wrappedSize: 40)

        XCTAssertEqual(wrappedKeySize, 32)
    }
    
    func testKeyWrapPassedArguments() throws {
        CCSymmetricKeyWrapConfiguration.current = .pass
        
        _ = try AESKeyWrap(key, using: kek)

        let expectedArguments = CCSymmetricKeyWrapArguments(rawKey: key, kek: kek)
        XCTAssertEqual(CCSymmetricKeyWrapArguments.current, expectedArguments)
    }
    
    func testKeyWrapSuccess() throws {
        CCSymmetricKeyWrapConfiguration.current = .success(bytes: wrappedKey)
        
        let result = try AESKeyWrap(key, using: kek)
        
        XCTAssertEqual(result, wrappedKey)
    }
    
    func testKeyWrapFailure() {
        CCSymmetricKeyWrapConfiguration.current = .failure
        
        XCTAssertThrowsError(try AESKeyWrap(key, using: kek)) { error in
            XCTAssertEqual(error as? AESKeyWrapError, AESKeyWrapError.keyWrapFailure)
        }
    }

    func testKeyUnwrapPassedArguments() throws {
        CCSymmetricKeyUnwrapConfiguration.current = .pass

        _ = try AESKeyUnwrap(wrappedKey, using: kek)

        let expectedArguments = CCSymmetricKeyUnwrapArguments(wrappedKey: wrappedKey, kek: kek)
        XCTAssertEqual(CCSymmetricKeyUnwrapArguments.current, expectedArguments)
    }

    func testKeyUnwrapSuccess() throws {
        CCSymmetricKeyUnwrapConfiguration.current = .success(key: key)

        let result = try AESKeyUnwrap(wrappedKey, using: kek)

        XCTAssertEqual(result, key)
    }
    
    func testKeyUnwrapFailure() {
        CCSymmetricKeyUnwrapConfiguration.current = .failure

        XCTAssertThrowsError(try AESKeyUnwrap(wrappedKey, using: kek)) { error in
            XCTAssertEqual(error as? AESKeyUnwrapError, AESKeyUnwrapError.keyUnwrapFailure)
        }
    }
    
}
