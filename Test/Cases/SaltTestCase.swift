import CommonCrypto
import XCTest

class SaltTestCase: XCTestCase {
    
    func testRandomNumberGeneratorFailure() {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.failure()

        XCTAssertThrowsError(try Salt(size: 0)) { error in
            XCTAssertEqual(error as? SaltError, SaltError.randomNumberGeneratorFailure)
        }
        
        addTeardownBlock {
            CCRandomGenerateBytesConfiguration.current = nil
        }
    }

    func testZeroCount() throws {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.zeroCount()

        try Salt(size: 0).withUnsafeBytes { salt in
            XCTAssertEqual(salt.count, 0)
        }

        addTeardownBlock {
            CCRandomGenerateBytesConfiguration.current = nil
        }
    }

    func testEveryByteValue() throws {
        let expectedBytes = Array(0 ..< UInt8.max)
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.withBytes(expectedBytes)

        let saltSize = Int(UInt8.max)
        try Salt(size: saltSize).withUnsafeBytes { salt in
            let resultBytes = Array(salt)
            XCTAssertEqual(resultBytes, expectedBytes)
        }
        
        addTeardownBlock {
            CCRandomGenerateBytesConfiguration.current = nil
        }
    }
    
}
