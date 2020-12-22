import XCTest
@testable import Store

class LoginCredentialTests: XCTestCase {
    
    func testInit() {
        let expectedID = UUID()
        let credential = LoginCredential(id: expectedID, title: "foo", username: "bar", password: "baz", url: "qux")
        
        XCTAssertEqual(credential.id, expectedID)
        XCTAssertEqual(credential.title, "foo")
        XCTAssertEqual(credential.username, "bar")
        XCTAssertEqual(credential.password, "baz")
        XCTAssertEqual(credential.url, "qux")
    }
    
}
