import XCTest
@testable import Store

class LoginTests: XCTestCase {
    
    func testInit() {
        let item = LoginItem(username: "foo", password: "bar", url: "baz")
        
        XCTAssertEqual(item.username, "foo")
        XCTAssertEqual(item.password, "bar")
        XCTAssertEqual(item.url, "baz")
    }
    
}
