import CoreCrypto
import XCTest
@testable import Crypto

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
