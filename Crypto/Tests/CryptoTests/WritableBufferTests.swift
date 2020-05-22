import XCTest
@testable import Crypto

class WritableBufferTests: XCTestCase {
    
    func testContinousBytes() {
        let pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: 1, alignment: MemoryLayout<UInt8>.alignment)
        addTeardownBlock {
            pointer.deallocate()
        }
        
        XCTAssertEqual(pointer.baseAddress, pointer.continousBytes.baseAddress)
    }
    
}
