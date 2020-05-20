import XCTest
@testable import Crypto

final class VersionRepresentableTests: XCTestCase {
    
    func testInitSuccess() throws {
        let version = try VersionMock(1)
        
        XCTAssertEqual(version, VersionMock.version1)
    }
    
    func testInitFailureInvalidData() {
        XCTAssertThrowsError(try VersionMock("0000"))
    }
    
    func testInitFailureUnsupportedVersion() {
        XCTAssertThrowsError(try VersionMock(2))
    }
    
    func testEncoded() throws {
        XCTAssertEqual(VersionMock.version1.encoded, 1)
    }
    
}

private enum  VersionMock: UInt8, VersionRepresentable {
    
    case version1 = 1
    
}
