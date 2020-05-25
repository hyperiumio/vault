import CommonCrypto
import XCTest
@testable import Crypto

class RandomBytesTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        RandomBytesRNG = { _, _ in fatalError() }
    }
    
    override func tearDown() {
        RandomBytesRNG = CCRandomGenerateBytes
        
        super.tearDown()
    }
    
    func testZeroCount() throws {
        RandomBytesRNG = { _, _ in CCRNGStatus(kCCSuccess) }
        
        let randomData = try RandomBytes(count: 0)
        
        XCTAssertEqual(randomData, .empty)
    }
    
    func testReturnsRandomBytes() throws {
        let expectedData = Data(0 ... UInt8.max)
        
        RandomBytesRNG = { buffer, count in
            expectedData.withUnsafeBytes { expectedData in
                buffer?.copyMemory(from: expectedData.baseAddress!, byteCount: count)
            }
            
            return Int32(kCCSuccess)
        }
        
        let randomData = try RandomBytes(count: expectedData.count)
        
        XCTAssertEqual(randomData, expectedData)
    }
    
    func testFailure() {
        RandomBytesRNG = { bytes, count in -1 }
        
        XCTAssertThrowsError(try RandomBytes(count: 0))
    }
    
}
