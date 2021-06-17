import XCTest
@testable import Model

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
        """ as Data
        
        let item = try WifiItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.password, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try WifiItem(from: data))
    }
    
    func testSecureItemType() {
        let item = WifiItem(name: "", password: "")
        
        XCTAssertEqual(item.secureItemType, .wifi)
        XCTAssertEqual(WifiItem.secureItemType, .wifi)    }
    
    func testEncoded() throws {
        let item = try WifiItem(name: "foo", password: "bar").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "name": "foo",
            "password": "bar"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
