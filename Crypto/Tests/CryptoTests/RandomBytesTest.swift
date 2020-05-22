import CommonCrypto
import XCTest
@testable import Crypto

class RandomBytesTest: XCTestCase {
    
    func testZeroCount() throws {
        let expectedByteCount = 0
        
        func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer {
            XCTAssertEqual(byteCount, expectedByteCount)
            XCTAssertEqual(alignment, MemoryLayout<UInt8>.alignment)
            
            return UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
        }
        
        let rng = RandomNumberGenerator(allocate: allocate)
        
        let randomData = try rng.generate(count: expectedByteCount)
        
        XCTAssertEqual(randomData.count, expectedByteCount)
    }
    
    func testReturnsRandomBytes() throws {
        let expectedData = Data(0 ... UInt8.max)
        let extendedBufferCount = expectedData.count + 1
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: extendedBufferCount, alignment: MemoryLayout<UInt8>.alignment)
        buffer.storeBytes(of: UInt8.max, toByteOffset: expectedData.endIndex, as: UInt8.self)
        
        func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer {
            XCTAssertEqual(byteCount, expectedData.count)
            XCTAssertEqual(alignment, MemoryLayout<UInt8>.alignment)
            
            return buffer
        }
        
        func generate(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            expectedData.withUnsafeBytes { bytes in
                buffer?.copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
            }
            
            return Int32(kCCSuccess)
        }
        
        let rng = RandomNumberGenerator(allocate: allocate, generate: generate)
        
        let randomData = try rng.generate(count: expectedData.count)
        let beyondBufferByte = buffer.load(fromByteOffset: expectedData.endIndex, as: UInt8.self)
        
        XCTAssertEqual(randomData, expectedData)
        XCTAssertEqual(beyondBufferByte, UInt8.max)
        for (index, expectedByte) in expectedData.enumerated() {
            let byte = buffer.load(fromByteOffset: index, as: UInt8.self)
            XCTAssertEqual(byte, expectedByte)
        }
    }
    
    func testFailure() {
        
        func generate(buffer: UnsafeMutableRawPointer?, count: Int) -> Int32 {
            return Int32(kCCRNGFailure)
        }
        
        let rng = RandomNumberGenerator(generate: generate)
        
        XCTAssertThrowsError(try rng.generate(count: 0))
    }
    
}
