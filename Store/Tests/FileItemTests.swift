import XCTest
@testable import Store

class FileItemTests: XCTestCase {
    
    func testInit() {
        let everyByteValue = Data(0 ... UInt8.max)
        let item = FileItem(name: "foo", data: everyByteValue)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.data, everyByteValue)
    }
    
    func testInitNoData() {
        let item = FileItem(name: "foo", data: nil)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertNil(item.data)
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
    
}
