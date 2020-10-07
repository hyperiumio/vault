import XCTest
@testable import Store

class CustomFieldTests: XCTestCase {
    
    func testInit() {
        let item = CustomItem(name: "foo", value: "bar")
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.value, "bar")
    }
    
}
