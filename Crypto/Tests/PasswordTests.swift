import CommonCrypto
import XCTest
@testable import Crypto

class PasswordTests: XCTestCase {
    
    func testEmptySymbolGroup() {
        XCTAssertThrowsError(try PasswordGenerator(length: 0, uppercase: false, lowercase: false, digit: false, symbol: false))
    }
    
    func testLengthGreaterThanSymbolGroupCount() {
        XCTAssertThrowsError(try PasswordGenerator(length: 1, uppercase: true, lowercase: true, digit: true, symbol: true))
    }
    
    func testRandomCallArguments() throws {
        let configuration = PasswordConfiguration { bytes, count in
            XCTAssertEqual(count, 1)
            XCTAssertNotNil(bytes)
            
            bytes.storeBytes(of: 0, as: UInt8.self)
            return CCRNGStatus(kCCSuccess)
        }
        _ = try PasswordGenerator(length: 1, uppercase: true, lowercase: false, digit: false, symbol: false, configuration: configuration)
    }
    
    func testEverySymbolGroupPresent() throws {
        let characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        var index = 0 as UInt8
        let configuration = PasswordConfiguration { bytes, _ in
            bytes.storeBytes(of: index, as: UInt8.self)
            index += 1
            
            return CCRNGStatus(kCCSuccess)
        }
        let password = try PasswordGenerator(length: characterSet.count, uppercase: true, lowercase: true, digit: true, symbol: true, configuration: configuration)
        
        XCTAssertEqual(Set(password), Set(characterSet))
    }
    
    func testInvalidPassword() throws {
        let characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        var callCount = 0
        var index = 0 as UInt8
        let configuration = PasswordConfiguration { bytes, _ in
            callCount += 1
            if callCount > characterSet.count {
                bytes.storeBytes(of: index, as: UInt8.self)
                index += 1
            } else {
                bytes.storeBytes(of: 0, as: UInt8.self)
            }
            
            return CCRNGStatus(kCCSuccess)
        }
        
        _ = try PasswordGenerator(length: characterSet.count, uppercase: true, lowercase: true, digit: true, symbol: true, configuration: configuration)
    }
    
    func testRNGFailure() {
        let configuration = PasswordConfiguration { _, _ in
            CCRNGStatus(kCCRNGFailure)
        }
        
        XCTAssertThrowsError(try PasswordGenerator(length: 4, uppercase: true, lowercase: true, digit: true, symbol: true, configuration: configuration))
    }
    
}
