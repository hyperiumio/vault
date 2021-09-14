import XCTest
@testable import Pasteboard

/*
class SystemPasteboardMock: SystemPasteboardRepresentable {
    
    private let expectation: [Event]
    private let output: Output
    private var recorded = [Event]()
    
    init(expectation: [Event] = [], output: Output = Output()) {
        self.expectation = expectation
        self.output = output
    }
    
    func clearContents() -> Int {
        recorded.append(.clearContents)
        return 0
    }
    
    func string(forType dataType: NSPasteboard.PasteboardType) -> String? {
        let call = Event.string(dataType: dataType)
        recorded.append(call)
        return output.stringForType
    }
    
    func setString(_ string: String, forType dataType: NSPasteboard.PasteboardType) -> Bool {
        let call = Event.setString(string: string, dataType: dataType)
        recorded.append(call)
        return true
    }
    
    func validate() {
        XCTAssertEqual(recorded, expectation)
    }
    
}

extension SystemPasteboardMock {
    
    enum Event: Equatable {
        
        case clearContents
        case string(dataType: NSPasteboard.PasteboardType)
        case setString(string: String, dataType: NSPasteboard.PasteboardType)
        
    }
    
    struct Output {
        
        let stringForType: String?
        
        init(stringForType: String? = nil) {
            self.stringForType = stringForType
        }
        
    }
    
}*/
