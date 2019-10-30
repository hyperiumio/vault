import CryptoKit
import XCTest

class CCRandomGenerateBytesTestCase: XCTestCase {

    override func tearDown() {
        super.tearDown()

        CCRandomGenerateBytesConfiguration.current = nil
    }

    func testFailureConfiguration() {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.failure()
        var buffer = [UInt8]()

        let status = CCRandomGenerateBytes(&buffer, buffer.count)

        XCTAssertNotEqual(status, kCCSuccess)
    }

    func testZeroCountConfiguration() {
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.zeroCount()
        var buffer = [UInt8]()

        let status = CCRandomGenerateBytes(&buffer, buffer.count)

        XCTAssertEqual(status, kCCSuccess)
    }

    func testEveryByteValueConfiguration() {
        let expectedBytes = Array(0 ... UInt8.max)
        CCRandomGenerateBytesConfiguration.current = CCRandomGenerateBytesConfiguration.withBytes(expectedBytes)
        var buffer = expectedBytes.map { value in
            return ~value
        }

        let status = CCRandomGenerateBytes(&buffer, buffer.count)

        XCTAssertEqual(status, kCCSuccess)
        XCTAssertEqual(buffer, expectedBytes)
    }

}
