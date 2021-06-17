import XCTest
@testable import Model

class LoginItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = LoginItem(username: "foo", password: "bar", url: "baz")
        
        XCTAssertEqual(item.username, "foo")
        XCTAssertEqual(item.password, "bar")
        XCTAssertEqual(item.url, "baz")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "username": "foo",
          "password": "bar",
          "url": "baz"
        }
        """ as Data
        
        let item = try LoginItem(from: data)
        
        XCTAssertEqual(item.username, "foo")
        XCTAssertEqual(item.password, "bar")
        XCTAssertEqual(item.url, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try LoginItem(from: data))
    }
    
    func testSecureItemType() {
        let item = LoginItem(username: "", password: "", url: "")
        
        XCTAssertEqual(item.secureItemType, .login)
        XCTAssertEqual(LoginItem.secureItemType, .login)
    }
    
    func testEncoded() throws {
        let item = try LoginItem(username: "foo", password: "bar", url: "baz").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "username": "foo",
            "password": "bar",
            "url": "baz"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
