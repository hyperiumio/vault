import XCTest
@testable import Store

class FileItemTests: XCTestCase {
    
    func testInitFromValues() {
        let everyByteValue = Data(0 ... UInt8.max)
        let item = FileItem(data: everyByteValue, typeIdentifier: .item)
        
        XCTAssertEqual(item.data, everyByteValue)
        XCTAssertEqual(item.typeIdentifier, .item)
    }
    
    func testInitFromData() throws {
        let infoSegment = """
        {
          "typeIdentifier": "public.item"
        }
        """.data(using: .utf8)!
        let dataSegment = Data(0 ... UInt8.max)
        let infoSize = UInt32Encode(infoSegment.count)
        let dataSize = UInt32Encode(dataSegment.count)
        let data = infoSize + infoSegment + dataSize + dataSegment
        
        let item = try FileItem(from: data)
        
        XCTAssertEqual(item.data, dataSegment)
        XCTAssertEqual(item.typeIdentifier, .item)
    }
    
    func testInitFromDataWithInfoSegmentSizeTooShort() {
        let data = Data()
        
        XCTAssertThrowsError(try FileItem(from: data))
    }
    
    func testInitFromDataWithInfoSegmentTooShort() {
        let data = UInt32Encode(1)
        
        XCTAssertThrowsError(try FileItem(from: data))
    }
    
    func testInitFromDataWithDataSegmentSizeTooShort() {
        let infoSegment = """
        {
          "name": "foo"
        }
        """.data(using: .utf8)!
        let data = UInt32Encode(infoSegment.count) + infoSegment
        
        XCTAssertThrowsError(try FileItem(from: data))
    }
    
    func testInitFromDataWithDataSegmentTooShort() {
        let infoSegment = """
        {
          "name": "foo"
        }
        """.data(using: .utf8)!
        let data = UInt32Encode(infoSegment.count) + infoSegment + UInt32Encode(1)
        
        XCTAssertThrowsError(try FileItem(from: data))
    }
    
    func testInitFromDataWithDataSegmentTooLong() {
        let infoSegment = """
        {
          "name": "foo"
        }
        """.data(using: .utf8)!
        let data = UInt32Encode(infoSegment.count) + infoSegment + UInt32Encode(0) + Data(repeating: 0, count: 1)
        
        XCTAssertThrowsError(try FileItem(from: data))
    }
    
    
    func testType() {
        let item = FileItem(data: Data(), typeIdentifier: .item)
        
        XCTAssertEqual(item.secureItemType, .file)
    }
    
    func testEncoded() throws {
        continueAfterFailure = false
        
        let expectedData = Data(0 ... UInt8.max)
        let item = try FileItem(data: expectedData, typeIdentifier: .item).encoded()
        
        XCTAssertGreaterThanOrEqual(item.count, UInt32CodingSize)
        
        let infoSizeDataRange = Range(item.startIndex, count: UInt32CodingSize)
        let infoSizeData = item[infoSizeDataRange]
        let infoSize = UInt32Decode(infoSizeData) as Int
        
        XCTAssertGreaterThanOrEqual(item.count, UInt32CodingSize + infoSize)
        
        let infoSegmentRange = Range(infoSizeDataRange.upperBound, count: infoSize)
        let infoSegment = item[infoSegmentRange]
        
        XCTAssertGreaterThanOrEqual(item.count, UInt32CodingSize + infoSize + UInt32CodingSize)
        
        let dataSizeDataRange = Range(infoSegmentRange.upperBound, count: UInt32CodingSize)
        let dataSizeData = item[dataSizeDataRange]
        let dataSize = UInt32Decode(dataSizeData) as Int
        
        XCTAssertEqual(item.count, UInt32CodingSize + infoSize + UInt32CodingSize + dataSize)
        
        let dataSegmentRange = Range(dataSizeDataRange.upperBound, count: dataSize)
        let dataSegment = item[dataSegmentRange]
        
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: infoSegment) as? [String: Any])
        let typeIdentifier = try XCTUnwrap(json["typeIdentifier"] as? String)
        
        XCTAssertEqual(typeIdentifier, "public.item")
        XCTAssertEqual(dataSegment, expectedData)
    }
    
}
