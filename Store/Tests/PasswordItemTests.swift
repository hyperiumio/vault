import XCTest
@testable import Store

class PasswordItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = PasswordItem(password: "foo")
        
        XCTAssertEqual(item.password, "foo")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "password": "foo"
        }
        """.data(using: .utf8)!
        
        let item = try PasswordItem(from: data)
        
        XCTAssertEqual(item.password, "foo")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try PasswordItem(from: data))
    }
    
    func testType() {
        let item = PasswordItem(password: "")
        
        XCTAssertEqual(item.type, .password)
    }
    
    func testEncoded() throws {
        let item = try PasswordItem(password: "foo").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let password = try XCTUnwrap(json["password"] as? String)
        
        XCTAssertEqual(json.count, 1)
        XCTAssertEqual(password, "foo")
    }
    
}
