import CommonCrypto
import CryptoKit
import XCTest
@testable import Crypto

class DerivedKeyTests: XCTestCase {
    
    func testDerivedKeyInitFromData() {
        let keyData = Data(0 ..< 32)
        let expectedKey = SymmetricKey(data: keyData)
        let derivedKey = DerivedKey(keyData)
        
        XCTAssertEqual(derivedKey.value, expectedKey)
    }
    
    func testDerivedKeyInitFromArguments() throws {
        let salt = [UInt8](repeating: 0, count: 32)
        let rounds = [1, 0, 0, 0] as [UInt8]
        let derivedKeyContainer = Data(salt + rounds)
        let keyData = [160, 172, 145, 150, 69, 134, 235, 176, 226, 167, 116, 34, 123, 31, 108, 208, 49, 231, 71, 212, 129, 55, 35, 165, 226, 33, 76, 245, 0, 51, 19, 216] as [UInt8]
        let expectedKey = SymmetricKey(data: keyData)
        let arguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
        let derivedKey = try DerivedKey(from: "", with: arguments)
        
        XCTAssertEqual(derivedKey.value, expectedKey)
    }
    
    func testDerivedKeyInitFromArgumentsInvalidRounds() throws {
        let salt = [UInt8](repeating: 0, count: 32)
        let rounds = [0, 0, 0, 0] as [UInt8]
        let derivedKeyContainer = Data(salt + rounds)
        let arguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
        
        XCTAssertThrowsError(try DerivedKey(from: "", with: arguments))
    }
    
    func testDerivedKeyWithUnsafeBytes() {
        let data = Array(0 ... UInt8.max)
        let derivedKeyData = DerivedKey(data).withUnsafeBytes { bytes in
            Array(bytes)
        }
            
        XCTAssertEqual(derivedKeyData, data)
    }
    
    func testPublicArgumentsInit() throws {
        let expectedSalt = Data(0 ..< 32)
        let arguments = try DerivedKey.PublicArguments { buffer, count in
            expectedSalt.withUnsafeBytes { expectedSaltBytes in
                buffer!.copyMemory(from: expectedSaltBytes.baseAddress!, byteCount: count)
            }
            
            return CCRNGStatus(kCCSuccess)
        }
        
        XCTAssertEqual(arguments.salt, expectedSalt)
        XCTAssertEqual(arguments.rounds, 524288)
    }
    
    func testPublicArgumentsInitRNGFailure() {
        let rng = { _, _ in
            CCRNGStatus(kCCRNGFailure)
        } as DerivedKey.PublicArguments.RNG
        
        XCTAssertThrowsError(try DerivedKey.PublicArguments(rng: rng))
    }
    
    func testPublicArgumentsInitFromContainer() throws {
        let expectedSalt = Data(0 ..< 32)
        let rounds = [1, 0, 0, 0] as [UInt8]
        let container = expectedSalt + rounds
        let arguments = try DerivedKey.PublicArguments(from: container)
        
        XCTAssertEqual(arguments.salt, expectedSalt)
        XCTAssertEqual(arguments.rounds, 1)
    }
    
    func testPublicArgumentsInitFromContainerInvalidContainerSize() {
        let container = Data()
        
        XCTAssertThrowsError(try DerivedKey.PublicArguments(from: container))
    }
    
    func testPublicArgumentsContainer() throws {
        let expectedSalt = Data(0 ..< 32)
        let rounds = [0, 0, 8, 0] as [UInt8]
        let expectedContainer = expectedSalt + rounds
        let container = try DerivedKey.PublicArguments { buffer, count in
            expectedSalt.withUnsafeBytes { expectedSaltBytes in
                buffer!.copyMemory(from: expectedSaltBytes.baseAddress!, byteCount: count)
            }
            
            return CCRNGStatus(kCCSuccess)
        }.container()
        
        XCTAssertEqual(container, expectedContainer)
    }
    
}
