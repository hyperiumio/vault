import XCTest
@testable import Store

class NoteTests: XCTestCase {
    
    func testInit() {
        let item = NoteItem(text: "foo")
        
        XCTAssertEqual(item.text, "foo")
    }
    
}
