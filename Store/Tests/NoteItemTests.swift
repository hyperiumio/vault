import XCTest
@testable import Storage

class NoteItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = NoteItem(text: "foo")
        
        XCTAssertEqual(item.text, "foo")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "text": "foo"
        }
        """.data(using: .utf8)!
        
        let item = try NoteItem(from: data)
        
        XCTAssertEqual(item.text, "foo")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try NoteItem(from: data))
    }
    
    func testSecureItemType() {
        let item = NoteItem(text: "")
        
        XCTAssertEqual(item.secureItemType, .note)
        XCTAssertEqual(NoteItem.secureItemType, .note)
    }
    
    func testEncoded() throws {
        let item = try NoteItem(text: "foo").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let text = try XCTUnwrap(json["text"] as? String)
        
        XCTAssertEqual(json.count, 1)
        XCTAssertEqual(text, "foo")
    }
    
}
