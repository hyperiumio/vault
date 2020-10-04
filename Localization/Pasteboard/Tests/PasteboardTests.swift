import XCTest
@testable import Pasteboard

#if canImport(AppKit)
final class PasteboardTests: XCTestCase {
    
    func testGetString() {
        let expectation = [
            .string(dataType: .string)
        ] as [SystemPasteboardMock.Call]
        let mock = SystemPasteboardMock(expectation)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        _ = pasteboard.string
        
        mock.validate()
    }
    
    func testSetStringNil() {
        let expectation = [
            .clearContents
        ] as [SystemPasteboardMock.Call]
        let mock = SystemPasteboardMock(expectation)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        pasteboard.string = nil
        
        mock.validate()
    }
    
    func testSetStringValue() {
        let expectation = [
            .clearContents,
            .setString(string: "abc", dataType: .string)
        ] as [SystemPasteboardMock.Call]
        let mock = SystemPasteboardMock(expectation)
        let pasteboard = Pasteboard(systemPasteboard: mock)
        
        pasteboard.string = "abc"
        
        mock.validate()
    }
    
    
}

private class SystemPasteboardMock: SystemPasteboardRepresentable {
    
    private let expectation: [Call]
    private var recorded = [Call]()
    
    init(_ expectation: [Call]) {
        self.expectation = expectation
    }
    
    func clearContents() -> Int {
        recorded.append(.clearContents)
        return 0
    }
    
    func string(forType dataType: NSPasteboard.PasteboardType) -> String? {
        let call = Call.string(dataType: dataType)
        recorded.append(call)
        return nil
    }
    
    func setString(_ string: String, forType dataType: NSPasteboard.PasteboardType) -> Bool {
        let call = Call.setString(string: string, dataType: dataType)
        recorded.append(call)
        return true
    }
    
    func validate() {
        XCTAssertEqual(recorded, expectation)
    }
    
}

extension SystemPasteboardMock {
    
    enum Call: Equatable {
        
        case clearContents
        case string(dataType: NSPasteboard.PasteboardType)
        case setString(string: String, dataType: NSPasteboard.PasteboardType)
        
    }
    
}
#endif
