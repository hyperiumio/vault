import XCTest
@testable import Identifier

final class IdentifierTests: XCTestCase {
    
    func testCloudContainerID() {
        XCTAssertEqual(Identifier.cloudContainer, "group.io.hyperium.vault.default")
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
