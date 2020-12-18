import XCTest
@testable import Crypto

class UnsignedInteger32BitCodingTests: XCTestCase {
    
    func testEncodeUInt32() {
        let data = UnsignedInteger32BitEncode(67305985)
        let expectedData = Data([1, 2, 3, 4])
        
        XCTAssertEqual(data, expectedData)
    }
    
    
    func testDecodeUInt32SliceIndependent() {
        let dataChunk = Data([255, 1, 2, 3, 4])
        let data = dataChunk[1...]
        let value = UnsignedInteger32BitDecode(data) as UInt32
        
        XCTAssertEqual(value, 67305985)
    }
    
}
