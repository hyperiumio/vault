import XCTest
@testable import Store

class PasswordTests: XCTestCase {
    
    func testInit() {
        let item = PasswordItem(password: "foo")
        
        XCTAssertEqual(item.password, "foo")
    }
    
}
