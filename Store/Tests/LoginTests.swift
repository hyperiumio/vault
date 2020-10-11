import XCTest
@testable import Store

class LoginTests: XCTestCase {
    
    func testInit() {
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
        """.data(using: .utf8)!
        
        let item = try LoginItem(from: data)
        
        XCTAssertEqual(item.username, "foo")
        XCTAssertEqual(item.password, "bar")
        XCTAssertEqual(item.url, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try LoginItem(from: data))
    }
    
    func testType() {
        let item = LoginItem(username: "", password: "", url: "")
        
        XCTAssertEqual(item.type, .login)
    }
    
    func testEncoded() throws {
        let item = try LoginItem(username: "foo", password: "bar", url: "baz").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let username = try XCTUnwrap(json["username"] as? String)
        let password = try XCTUnwrap(json["password"] as? String)
        let url = try XCTUnwrap(json["url"] as? String)
        
        XCTAssertEqual(json.count, 3)
        XCTAssertEqual(username, "foo")
        XCTAssertEqual(password, "bar")
        XCTAssertEqual(url, "baz")
    }
    
}
