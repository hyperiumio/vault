import CommonCrypto
import XCTest

class SaltTestCase: XCTestCase {

    override func tearDown() {
        super.tearDown()

        CCRandomGenerateBytesConfiguration.current = nil
    }

    func testRandomNumberGeneratorFailure() {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.failure()

        XCTAssertThrowsError(try Salt(size: 0)) { error in
            XCTAssertEqual(error as? SaltError, SaltError.randomNumberGeneratorFailure)
        }
    }

    func testZeroCount() throws {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.zeroCount()

        try Salt(size: 0).withUnsafeBytes { salt in
            XCTAssertEqual(salt.count, 0)
        }
    }

    func testEveryByteValue() throws {
        let expectedBytes = Array(0 ... UInt8.max)
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.withBytes(expectedBytes)

        try Salt(size: expectedBytes.count).withUnsafeBytes { salt in
            let resultBytes = Array(salt)
            XCTAssertEqual(resultBytes, expectedBytes)
        }
    }
    
}
