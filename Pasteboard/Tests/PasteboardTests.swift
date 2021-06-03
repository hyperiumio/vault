import XCTest
@testable import Pasteboard

#if os(macOS)
final class PasteboardTests: XCTestCase {
    
    func testGetString() {
        let expectation = [
            SystemPasteboardMock.Event.string(dataType: .string)
        ]
        let output = SystemPasteboardMock.Output(stringForType: "abc")
        let mock = SystemPasteboardMock(expectation: expectation, output: output)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        let value = pasteboard.string
        
        mock.validate()
        XCTAssertEqual(value, "abc")
    }
    
    func testSetStringNil() {
        let expectation = [SystemPasteboardMock.Event.clearContents]
        let mock = SystemPasteboardMock(expectation: expectation)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        pasteboard.string = nil
        
        mock.validate()
    }
    
    func testSetStringValue() {
        let expectation = [
            SystemPasteboardMock.Event.clearContents,
            SystemPasteboardMock.Event.setString(string: "abc", dataType: .string)
        ]
        let mock = SystemPasteboardMock(expectation: expectation)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        pasteboard.string = "abc"
        
        mock.validate()
    }
    
}
#endif
