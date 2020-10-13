import XCTest
@testable import Store

class FileItemTests: XCTestCase {
    
    func testInitFromValues() {
        let everyByteValue = Data(0 ... UInt8.max)
        let item = FileItem(name: "foo", data: everyByteValue)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.data, everyByteValue)
    }
    
    func testInitFromValuesNoData() {
        let item = FileItem(name: "foo", data: nil)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertNil(item.data)
    }
    
    func testInitFromData() throws {
        let infoSegment = """
        {
          "name": "foo"
        }
        """.data(using: .utf8)!
        let dataSegment = Data(0 ... UInt8.max)
        let infoSize = UInt32Encode(infoSegment.count)
        let dataSize = UInt32Encode(dataSegment.count)
        let data = infoSize + infoSegment + dataSize + dataSegment
        
        let item = try FileItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.data, dataSegment)
    }
    
    func testInitFromDataNoDataSegment() throws {
        let infoSegment = """
        {
          "name": "foo"
        }
        """.data(using: .utf8)!
        let infoSize = UInt32Encode(infoSegment.count)
        let dataSize = UInt32Encode(0)
        let data = infoSize + infoSegment + dataSize
        
        let item = try FileItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertNil(item.data)
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
    
    func testFormatLowercase() {
        let pdf = FileItem(name: "file.pdf", data: nil).format
        let png = FileItem(name: "file.png", data: nil).format
        let jpg = FileItem(name: "file.jpg", data: nil).format
        let jpeg = FileItem(name: "file.jpeg", data: nil).format
        let gif = FileItem(name: "file.gif", data: nil).format
        let tif = FileItem(name: "file.tif", data: nil).format
        let tiff = FileItem(name: "file.tiff", data: nil).format
        let bmp = FileItem(name: "file.bmp", data: nil).format
        let unrepresentable = FileItem(name: "file.foo", data: nil).format
        
        XCTAssertEqual(pdf, .pdf)
        XCTAssertEqual(png, .image)
        XCTAssertEqual(jpg, .image)
        XCTAssertEqual(jpeg, .image)
        XCTAssertEqual(gif, .image)
        XCTAssertEqual(tif, .image)
        XCTAssertEqual(tiff, .image)
        XCTAssertEqual(bmp, .image)
        XCTAssertEqual(unrepresentable, .unrepresentable)
    }
    
    func testFormatUppercase() {
        let pdf = FileItem(name: "file.PDF", data: nil).format
        let png = FileItem(name: "file.PNG", data: nil).format
        let jpg = FileItem(name: "file.JPG", data: nil).format
        let jpeg = FileItem(name: "file.JPEG", data: nil).format
        let gif = FileItem(name: "file.GIF", data: nil).format
        let tif = FileItem(name: "file.TIF", data: nil).format
        let tiff = FileItem(name: "file.TIFF", data: nil).format
        let bmp = FileItem(name: "file.BMP", data: nil).format
        let unrepresentable = FileItem(name: "file.FOO", data: nil).format
        
        XCTAssertEqual(pdf, .pdf)
        XCTAssertEqual(png, .image)
        XCTAssertEqual(jpg, .image)
        XCTAssertEqual(jpeg, .image)
        XCTAssertEqual(gif, .image)
        XCTAssertEqual(tif, .image)
        XCTAssertEqual(tiff, .image)
        XCTAssertEqual(bmp, .image)
        XCTAssertEqual(unrepresentable, .unrepresentable)
    }
    
    func testType() {
        let item = FileItem(name: "", data: nil)
        
        XCTAssertEqual(item.type, .file)
    }
    
    func testEncoded() throws {
        continueAfterFailure = false
        
        let expectedData = Data(0 ... UInt8.max)
        let item = try FileItem(name: "foo", data: expectedData).encoded()
        
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
        let name = try XCTUnwrap(json["name"] as? String)
        
        XCTAssertEqual(name, "foo")
        XCTAssertEqual(dataSegment, expectedData)
    }
    
    func testEncodedEmptyDataSegment() throws {
        continueAfterFailure = false
        
        let item = try FileItem(name: "foo", data: nil).encoded()
        
        XCTAssertGreaterThanOrEqual(item.count, UInt32CodingSize)
        
        let infoSizeDataRange = Range(item.startIndex, count: UInt32CodingSize)
        let infoSizeData = item[infoSizeDataRange]
        let infoSize = UInt32Decode(infoSizeData) as Int
        
        XCTAssertEqual(item.count, UInt32CodingSize + infoSize + UInt32CodingSize)
        
        let dataSizeDataRange = Range(infoSizeDataRange.upperBound + infoSize, count: UInt32CodingSize)
        let dataSizeData = item[dataSizeDataRange]
        let dataSize = UInt32Decode(dataSizeData) as Int
        
        XCTAssertEqual(dataSize, 0)
    }
    
}
