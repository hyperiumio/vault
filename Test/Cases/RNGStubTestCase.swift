import CommonCrypto
import XCTest

class RNGStubTestCase: XCTestCase {
    
    var allBitsSetBuffer: [UInt8] {
        return Array(repeating: UInt8.max, count: 256)
    }
    
    func testFailure() {
        var buffer = allBitsSetBuffer
        let status = RNGStub(result: .failure)(&buffer, buffer.count)

        XCTAssertEqual(buffer, allBitsSetBuffer)
        XCTAssertNotEqual(status, .success)
    }

    func testZeroCount() {
        let rngBytes = [UInt8]()
        var buffer = allBitsSetBuffer
        
        let status = RNGStub(result: .success, bytes: rngBytes)(&buffer, buffer.count)

        XCTAssertEqual(buffer, allBitsSetBuffer)
        XCTAssertEqual(status, .success)
    }

    func testEveryByteValue() {
        let rngBytes = Array(0 ... UInt8.max)
        var buffer = rngBytes.map { value in
            return ~value
        }

        let status = RNGStub(result: .success, bytes: rngBytes)(&buffer, buffer.count)

        XCTAssertEqual(buffer, rngBytes)
        XCTAssertEqual(status, .success)
    }

}

private extension CCRNGStatus {
    
    static let success = CCRNGStatus(kCCSuccess)
    static let failure = CCRNGStatus(kCCUnspecifiedError)
    
}
