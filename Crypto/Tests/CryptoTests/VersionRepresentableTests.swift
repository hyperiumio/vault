import XCTest
@testable import Crypto

class VersionRepresentableTests: XCTestCase {
    
    func testInitSuccess() throws {
        let version = try VersionStub("01")
        
        XCTAssertEqual(version, VersionStub.version1)
    }
    
    func testInitIsDataSliceIndependent() throws {
        let data = Data("0001")
        let versionData = data[1 ..< 2]
        
        let version = try VersionStub(versionData)
        
        XCTAssertEqual(version, VersionStub.version1)
    }
    
    func testInitFailureInvalidData() {
        XCTAssertThrowsError(try VersionStub("0000"))
    }
    
    func testInitFailureUnsupportedVersion() {
        XCTAssertThrowsError(try VersionStub("02"))
    }
    
    func testEncoded() throws {
        XCTAssertEqual(VersionStub.version1.encoded, "01")
    }
    
}

private enum  VersionStub: UInt8, VersionRepresentable {
    
    case version1 = 1
    
}
