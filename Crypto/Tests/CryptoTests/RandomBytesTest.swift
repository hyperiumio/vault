import CommonCrypto
import XCTest
@testable import Crypto

final class RandomBytesTest: XCTestCase {
    
    func testZeroCount() throws {
        let randomData = try RandomBytes(count: 0)
        
        XCTAssertEqual(randomData.count, 0)
    }
    
    func testReturnsRandomBytes() throws {
        let expectedData = Data(0 ... UInt8.max)
        
        func rng(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            expectedData.withUnsafeBytes { bytes in
                buffer?.copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
            }
            
            return Int32(kCCSuccess)
        }
        
        let randomData = try RandomBytes(count: expectedData.count, rng: rng)
        
        XCTAssertEqual(randomData, expectedData)
    }
    
    func testFailure() {
        
        func rng(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            return Int32(kCCRNGFailure)
        }
        
        XCTAssertThrowsError(try RandomBytes(count: 0, rng: rng))
    }
    
}
