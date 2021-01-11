import XCTest
@testable import Storage

class WifiItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = WifiItem(name: "foo", password: "bar")
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.password, "bar")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "name": "foo",
          "password": "bar"
        }
        """.data(using: .utf8)!
        
        let item = try WifiItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.password, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try WifiItem(from: data))
    }
    
    func testSecureItemType() {
        let item = WifiItem(name: "", password: "")
        
        XCTAssertEqual(item.secureItemType, .wifi)
        XCTAssertEqual(WifiItem.secureItemType, .wifi)    }
    
    func testEncoded() throws {
        let item = try WifiItem(name: "foo", password: "bar").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let networkName = try XCTUnwrap(json["name"] as? String)
        let networkPassword = try XCTUnwrap(json["password"] as? String)
        
        XCTAssertEqual(json.count, 2)
        XCTAssertEqual(networkName, "foo")
        XCTAssertEqual(networkPassword, "bar")
    }
    
}
