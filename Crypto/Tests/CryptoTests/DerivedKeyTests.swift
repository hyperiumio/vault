import CoreCrypto
import XCTest
@testable import Crypto

class DerivedKeyTests: XCTestCase {
    
    func testKeyDerivationArguments() throws {
        let expectedSalt = Data(0 ..< 32)
        let expectedRounds = 1024
        let expectedKeySize = 32
        let expectedPassword = "foo"
        let expectedDerivedKey = UnsafeMutableRawBufferPointer.allocate(byteCount: expectedKeySize, alignment: MemoryLayout<UInt8>.alignment)
        
        func allocator(byteCount: Int, alignment: Int) -> WritableBuffer {
            return expectedDerivedKey
        }
        
        func keyDerivation(password: UnsafeRawPointer, passwordLen: Int, salt: UnsafeRawPointer, saltLen: Int, rounds: UInt32, derivedKey: UnsafeMutableRawPointer, derivedKeyLen: Int) -> Int32 {
            let password = Data(bytes: password, count: passwordLen).map { bytes in
                return String(bytes: bytes, encoding: .utf8)
            }
            let salt = Data(bytes: salt, count: saltLen)
            let rounds = Int(rounds)
            
            XCTAssertEqual(password, expectedPassword)
            XCTAssertEqual(salt, expectedSalt)
            XCTAssertEqual(rounds, expectedRounds)
            XCTAssertEqual(derivedKey, expectedDerivedKey.baseAddress)
            XCTAssertEqual(derivedKeyLen, expectedKeySize)
            
            return CoreCrypto.Success
        }
        
        _ = try DerivedKey(salt: expectedSalt, rounds: expectedRounds, keySize: expectedKeySize, password: expectedPassword, allocator: allocator, keyDerivation: keyDerivation)
    }
    
    func testMemoryManagement() throws {
        let keySize = 32
        
        let writableBufferMock = WritableBufferMock(byteCount: keySize, repeatingValue: UInt8.max)
        
        func allocator(byteCount: Int, alignment: Int) -> WritableBuffer {
            return writableBufferMock
        }
        
        func keyDerivation(password: UnsafeRawPointer, passwordLen: Int, salt: UnsafeRawPointer, saltLen: Int, rounds: UInt32, derivedKey: UnsafeMutableRawPointer, derivedKeyLen: Int) -> Int32 {
            return CoreCrypto.Success
        }
        
        _ = try DerivedKey(salt: .empty, rounds: 0, keySize: 0, password: "", allocator: allocator, keyDerivation: keyDerivation)
        
        XCTAssert(writableBufferMock.didCallDealloc)
        XCTAssert(writableBufferMock.didOverrideBytes)
    }
    
    func testResult() throws {
        let keySize = 32
        let expectedData = Data(0 ..< 32)
        
        func keyDerivation(password: UnsafeRawPointer, passwordLen: Int, salt: UnsafeRawPointer, saltLen: Int, rounds: UInt32, derivedKey: UnsafeMutableRawPointer, derivedKeyLen: Int) -> Int32 {
            for (index, byte) in expectedData.enumerated() {
                derivedKey.storeBytes(of: byte, toByteOffset: index, as: UInt8.self)
            }
            
            return CoreCrypto.Success
        }
        
        let data = try DerivedKey(salt: .empty, rounds: 0, keySize: keySize, password: "", keyDerivation: keyDerivation).withUnsafeBytes { key in
            return Data(key)
        }
        
        XCTAssertEqual(data, expectedData)
    }
    
    func testInvalidRounds() {
        let rounds = Int(UInt32.max) + 1
        
        XCTAssertThrowsError(try DerivedKey(salt: "", rounds: rounds, keySize: 0, password: ""))
    }
    
    func testKeyDerivationFailure() {
        
        func keyDerivation(password: UnsafeRawPointer?, passwordLen: Int, salt: UnsafeRawPointer?, saltLen: Int, rounds: UInt32, derivedKey: UnsafeMutableRawPointer?, derivedKeyLen: Int) -> Int32 {
            return -1
        }
        
        XCTAssertThrowsError(try DerivedKey(salt: .empty, rounds: 0, keySize: 0, password: "", keyDerivation: keyDerivation))
    }
    
}
