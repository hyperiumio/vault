import XCTest
@testable import Store

class UInt32CodingTests: XCTestCase {
    
    func testEncodeUInt32() {
        let data = UInt32Encode(67305985)
        let expectedData = Data([1, 2, 3, 4])
        
        XCTAssertEqual(data, expectedData)
    }
    
    
    func testDecodeUInt32SliceIndependent() {
        let dataChunk = Data([255, 1, 2, 3, 4])
        let data = dataChunk[1...]
        let value = UInt32Decode(data)
        
        XCTAssertEqual(value, 67305985)
    }
    
}
