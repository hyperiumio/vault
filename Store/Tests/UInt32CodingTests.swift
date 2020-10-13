import XCTest
@testable import Store

class UInt32CodingTests: XCTestCase {
    
    func testEncodeInt() {
        let data = UInt32Encode(134480385)
        
        XCTAssertEqual(data, Data([1, 2, 4, 8]))
    }
    
    func testSliceIndependentDecodeInt() {
        let dataChunk = Data([0, 1, 2, 4, 8])
        let data = dataChunk[1...]
        let value = UInt32Decode(data)
        
        XCTAssertEqual(value, 134480385)
    }
    
}
