import XCTest
@testable import Persistence

class CustomItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = CustomItem(description: "foo", value: "bar")
        
        XCTAssertEqual(item.description, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "description": "foo",
          "value": "bar"
        }
        """ as Data
        
        let item = try CustomItem(from: data)
        
        XCTAssertEqual(item.description, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try CustomItem(from: data))
    }
    
    func testSecureItemType() {
        let item = CustomItem(description: "", value: "")
        
        XCTAssertEqual(item.secureItemType, .custom)
        XCTAssertEqual(CustomItem.secureItemType, .custom)
    }
    
    func testEncoded() throws {
        let item = try CustomItem(description: "foo", value: "bar").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "description": "foo",
            "value": "bar"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
