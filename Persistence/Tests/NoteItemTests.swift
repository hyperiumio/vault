import XCTest
@testable import Persistence

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
        """ as Data
        
        let item = try NoteItem(from: data)
        
        XCTAssertEqual(item.text, "foo")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try NoteItem(from: data))
    }
    
    func testSecureItemType() {
        let item = NoteItem(text: "")
        
        XCTAssertEqual(item.secureItemType, .note)
        XCTAssertEqual(NoteItem.secureItemType, .note)
    }
    
    func testEncoded() throws {
        let item = try NoteItem(text: "foo").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let exptectedJson = [
            "text": "foo"
        ]
        
        XCTAssertEqual(json, exptectedJson)
    }
    
}
