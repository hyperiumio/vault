import XCTest
@testable import Identifier

final class IdentifierTests: XCTestCase {
    
    func testDerivedKey() {
        XCTAssertEqual(Identifier.derivedKey, "DerivedKey")
    }
    
    #if os(iOS)
    func testAppGroup() {
        XCTAssertEqual(Identifier.appGroup, "group.io.hyperium.vault")
    }
    #endif
    
    #if os(macOS)
    func testAppGroup() {
        XCTAssertEqual(Identifier.appGroup, "HX3QTQLX65.io.hyperium.vault")
    }
    #endif
    
}
