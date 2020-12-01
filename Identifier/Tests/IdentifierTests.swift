import XCTest
@testable import Identifier

final class IdentifierTests: XCTestCase {
    
    func testAppBundleID() {
        XCTAssertEqual(Identifier.appBundleID, "io.hyperium.vault")
    }
    
    func testCloudContainerID() {
        XCTAssertEqual(Identifier.cloudContainerID, "group.io.hyperium.vault.default")
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
