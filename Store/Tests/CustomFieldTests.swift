import XCTest
@testable import Store

class CustomFieldTests: XCTestCase {
    
    func testInitFromValues() {
        let item = CustomItem(name: "foo", value: "bar")
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "name": "foo",
          "value": "bar"
        }
        """.data(using: .utf8)!
        
        let item = try CustomItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try CustomItem(from: data))
    }
    
    func testType() {
        let item = CustomItem(name: "", value: "")
        
        XCTAssertEqual(item.type, .custom)
    }
    
    func testEncoded() throws {
        let item = try CustomItem(name: "foo", value: "bar").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let name = try XCTUnwrap(json["name"] as? String)
        let value = try XCTUnwrap(json["value"] as? String)
        
        XCTAssertEqual(json.count, 2)
        XCTAssertEqual(name, "foo")
        XCTAssertEqual(value, "bar")
    }
    
}
