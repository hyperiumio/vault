import CommonCrypto
import XCTest
@testable import Crypto

final class RandomBytesTest: XCTestCase {
    
    func testZeroCount() throws {
        let expectedByteCount = 0
        
        func allocator(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer {
            XCTAssertEqual(byteCount, expectedByteCount)
            XCTAssertEqual(alignment, MemoryLayout<UInt8>.alignment)
            
            return UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
        }
        
        let randomData = try RandomBytes(count: expectedByteCount, allocator: allocator)
        
        XCTAssertEqual(randomData.count, expectedByteCount)
    }
    
    func testReturnsRandomBytes() throws {
        let expectedData = Data(0 ... UInt8.max)
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: expectedData.count, alignment: MemoryLayout<UInt8>.alignment)
        
        func rng(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            expectedData.withUnsafeBytes { bytes in
                buffer?.copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
            }
            
            return Int32(kCCSuccess)
        }
        
        func allocator(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer {
            XCTAssertEqual(byteCount, expectedData.count)
            XCTAssertEqual(alignment, MemoryLayout<UInt8>.alignment)
            
            return buffer
        }
        
        let randomData = try RandomBytes(count: expectedData.count, rng: rng, allocator: allocator)
        
        XCTAssertEqual(randomData, expectedData)
        for (index, expectedByte) in expectedData.enumerated() {
            let byte = buffer.load(fromByteOffset: index, as: UInt8.self)
            XCTAssertEqual(byte, expectedByte)
        }
    }
    
    func testFailure() {
        
        func rng(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            return Int32(kCCRNGFailure)
        }
        
        XCTAssertThrowsError(try RandomBytes(count: 0, rng: rng))
    }
    
}
