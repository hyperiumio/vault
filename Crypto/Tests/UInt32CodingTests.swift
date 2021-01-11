import XCTest
@testable import Crypto

class UInt32CodingTests: XCTestCase {
    
    func testEncodeUInt32() {
        let data = UInt32Encode(67305985)
        let expectedData = Data([1, 2, 3, 4])
        
        XCTAssertEqual(data, expectedData)
    }
    
    
    func testDecodeUInt32() throws {
        let dataChunk = Data([255, 1, 2, 3, 4])
        let data = dataChunk[1...]
        let value = try UInt32Decode(data)
        
        XCTAssertEqual(value, 67305985)
    }
    
    func testDecodeUInt32InvalidDataSize() throws {
        let data = Data()
        
        XCTAssertThrowsError(try UInt32Decode(data))
    }
    
}
