import CommonCrypto
import CryptoKit
import XCTest
@testable import Crypto

class MasterKeyTests: XCTestCase {
    
    func testDerivedKeyInitFromData() {
        let keyData = Data(0 ..< 32)
        let expectedKey = SymmetricKey(data: keyData)
        let masterKey = MasterKey(keyData)
        
        XCTAssertEqual(masterKey.value, expectedKey)
    }
    
    func testInit() {
        let key = MasterKey()
        
        XCTAssertEqual(key.value.bitCount, SymmetricKeySize.bits256.bitCount)
    }
    
    func testInitFromEncryptedContainer() throws {
        let keyData = Array(repeating: UInt8.max, count: 32)
        let expectedKey = SymmetricKey(data: keyData)
        let prefix = [0] as [UInt8]
        let containerBytes = [133, 208, 73, 193, 145, 236, 235, 37, 246, 167, 22, 202, 87, 154, 38, 81, 253, 82, 20, 195, 48, 163, 38, 186, 98, 12, 5, 231, 155, 91, 35, 114, 206, 213, 130, 114, 117, 174, 133, 84, 89, 194, 130, 181, 178, 157, 173, 5, 36, 147, 6, 153, 177, 243, 167, 2, 176, 122, 128, 84] as [UInt8]
        let container = Data(prefix + containerBytes)[1...]
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = DerivedKey(derivedKeyData)
        let masterKey = try MasterKey(from: container, using: derivedKey)
        
        
        XCTAssertEqual(masterKey.value, expectedKey)
    }
    
    func testInitFromEncryptedKeyContainerInvalidContainer() {
        let container = Data()
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = DerivedKey(derivedKeyData)
        
        XCTAssertThrowsError(try MasterKey(from: container, using: derivedKey))
    }
    
    func testInitFromEncryptedContainerDecryptionFailure() {
        let containerBytes = [133, 208, 73, 193, 145, 236, 235, 37, 246, 167, 22, 202, 87, 154, 38, 81, 253, 82, 20, 195, 48, 163, 38, 186, 98, 12, 5, 231, 155, 91, 35, 114, 206, 213, 130, 114, 117, 174, 133, 84, 89, 194, 130, 181, 178, 157, 173, 5, 36, 147, 6, 153, 177, 243, 167, 2, 176, 122, 128, 84] as [UInt8]
        let container = Data(containerBytes)
        let derivedKeyData = Data(repeating: UInt8.max, count: 32)
        let derivedKey = DerivedKey(derivedKeyData)
        
        XCTAssertThrowsError(try MasterKey(from: container, using: derivedKey))
    }
    
    func testEncryptedContainer() throws {
        let derivedKeyData = Data(repeating: 0, count: 32)
        let derivedKey = DerivedKey(derivedKeyData)
        let masterKey = MasterKey()
        let container = try masterKey.encryptedContainer(using: derivedKey)
        
        XCTAssertEqual(container.count, 60)
    }
    
    func testEncryptedContainerEncryptionFailure() {
        let keyData = Data()
        let derivedKey = DerivedKey(keyData)
        let masterKey = MasterKey()
        
        XCTAssertThrowsError(try masterKey.encryptedContainer(using: derivedKey))
    }
    
}
