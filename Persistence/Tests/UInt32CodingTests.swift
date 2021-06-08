import XCTest
@testable import Persistence

class UInt32CodingTests: XCTestCase {
    
    func testEncodeUInt32() {
        let encodedValue = UInt32Encode(134480385)
        let expectedData = [
            0x01, 0x02, 0x04, 0x08
        ] as Data
        
        XCTAssertEqual(encodedValue, expectedData)
    }
    
    func testDecodeUInt32() throws {
        let data = [
            0xFF,
            0x01, 0x02, 0x04, 0x08
        ] as Data
        let encodedValue = data[1...]
        let value = try UInt32Decode(encodedValue)
        
        XCTAssertEqual(value, 134480385)
    }
    
    func testDecodeUInt32InvalidDataSize() throws {
        let data = Data()
        XCTAssertThrowsError(try UInt32Decode(data))
    }
    
}
