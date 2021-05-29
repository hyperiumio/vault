import CommonCrypto
import XCTest
@testable import Crypto

class PasswordTests: XCTestCase {
    
    func testEmptySymbolGroup() {
        XCTAssertThrowsError(try Password(length: 0, uppercase: false, lowercase: false, digit: false, symbol: false))
    }
    
    func testLengthGreaterThanSymbolGroupCount() {
        XCTAssertThrowsError(try Password(length: 1, uppercase: true, lowercase: true, digit: true, symbol: true))
    }
    
    func testRNGArguments() throws {
        let configuration = PasswordConfiguration(rng: rng)
        _ = try Password(length: 1, uppercase: true, lowercase: false, digit: false, symbol: false, configuration: configuration)
        
        func rng(bytes: UnsafeMutableRawPointer, count: Int) -> CCRNGStatus {
            XCTAssertEqual(count, 1)
            XCTAssertNotNil(bytes)
            bytes.storeBytes(of: 0, as: UInt8.self)
            
            return CCRNGStatus(kCCSuccess)
        }
    }
    
    func testEverySymbolGroupPresent() throws {
        let characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        var currentIndex = characterSet.startIndex
        let configuration = PasswordConfiguration(rng: rng)
        let password = try Password(length: characterSet.count, uppercase: true, lowercase: true, digit: true, symbol: true, configuration: configuration)
        
        XCTAssertEqual(Set(password), Set(characterSet))
        
        func rng(bytes: UnsafeMutableRawPointer, count: Int) -> CCRNGStatus {
            let byteIndex = characterSet.distance(from: characterSet.startIndex, to: currentIndex)
            let indexValue = UInt8(byteIndex)
            bytes.storeBytes(of: indexValue, as: UInt8.self)
            currentIndex = characterSet.index(after: currentIndex)
            
            return CCRNGStatus(kCCSuccess)
        }
    }
    
    func testInvalidPassword() throws {
        let characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        var callCount = 0
        var currentIndex = characterSet.startIndex
        let configuration = PasswordConfiguration(rng: rng)
        
        _ = try Password(length: characterSet.count, uppercase: true, lowercase: true, digit: true, symbol: true, configuration: configuration)
        
        func rng(bytes: UnsafeMutableRawPointer, count: Int) -> CCRNGStatus {
            callCount += 1
            if callCount > characterSet.count {
                let byteIndex = characterSet.distance(from: characterSet.startIndex, to: currentIndex)
                let indexValue = UInt8(byteIndex)
                bytes.storeBytes(of: indexValue, as: UInt8.self)
                currentIndex = characterSet.index(after: currentIndex)
            } else {
                bytes.storeBytes(of: 0, as: UInt8.self)
            }
            
            return CCRNGStatus(kCCSuccess)
        }
    }
    
    func testRNGFailure() {
        let configuration = PasswordConfiguration(rng: rng)
        
        XCTAssertThrowsError(try Password(length: 1, uppercase: true, lowercase: false, digit: false, symbol: false, configuration: configuration))
        
        func rng(bytes: UnsafeMutableRawPointer, count: Int) -> CCRNGStatus {
            CCRNGStatus(kCCRNGFailure)
        }
    }
    
}
