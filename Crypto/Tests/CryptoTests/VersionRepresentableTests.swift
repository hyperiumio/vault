import XCTest
@testable import Crypto

final class VersionRepresentableTests: XCTestCase {
    
    func testInitSuccess() throws {
        let version = try VersionMock("01")
        
        XCTAssertEqual(version, VersionMock.version1)
    }
    
    func testInitIsDataSliceIndependent() throws {
        let data = Data("0001")
        let versionData = data[1 ..< 2]
        
        let version = try VersionMock(versionData)
        
        XCTAssertEqual(version, VersionMock.version1)
    }
    
    func testInitFailureInvalidData() {
        XCTAssertThrowsError(try VersionMock("0000"))
    }
    
    func testInitFailureUnsupportedVersion() {
        XCTAssertThrowsError(try VersionMock("02"))
    }
    
    func testEncoded() throws {
        XCTAssertEqual(VersionMock.version1.encoded, "01")
    }
    
}

private enum  VersionMock: UInt8, VersionRepresentable {
    
    case version1 = 1
    
}
