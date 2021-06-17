import XCTest
@testable import Model

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
        """ as Data
        
        let item = try PasswordItem(from: data)
        
        XCTAssertEqual(item.password, "foo")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try PasswordItem(from: data))
    }
    
    func testSecureItemType() {
        let item = PasswordItem(password: "")
        
        XCTAssertEqual(item.secureItemType, .password)
        XCTAssertEqual(PasswordItem.secureItemType, .password)
    }
    
    func testEncoded() throws {
        let item = try PasswordItem(password: "foo").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "password": "foo"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
