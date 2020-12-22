import XCTest
@testable import Store

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
        """.data(using: .utf8)!
        
        let item = try CustomItem(from: data)
        
        XCTAssertEqual(item.description, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try CustomItem(from: data))
    }
    
    func testType() {
        let item = CustomItem(description: "", value: "")
        
        XCTAssertEqual(item.secureItemType, .custom)
        XCTAssertEqual(CustomItem.secureItemType, .custom)
    }
    
    func testEncoded() throws {
        let item = try CustomItem(description: "foo", value: "bar").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let name = try XCTUnwrap(json["description"] as? String)
        let value = try XCTUnwrap(json["value"] as? String)
        
        XCTAssertEqual(json.count, 2)
        XCTAssertEqual(name, "foo")
        XCTAssertEqual(value, "bar")
    }
    
}
