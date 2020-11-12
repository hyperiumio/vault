import XCTest
@testable import Store

class VaultResourceLocatorTests: XCTestCase {
    
    let rootUrl = URL(string: "file://foo")!
    
    func testInit() {
        let rootDirectory = VaultResourceLocator(rootUrl).rootDirectory
        
        XCTAssertEqual(rootDirectory.absoluteString, "file://foo")
    }
    
    func testDerivedKeyFile() {
        let keyFile = VaultResourceLocator(rootUrl).derivedKeyContainer
        
        XCTAssertEqual(keyFile.absoluteString, "file://foo/DerivedKeyContainer")
    }
    
    func testMasterKeyFile() {
        let keyFile = VaultResourceLocator(rootUrl).masterKeyContainer
        
        XCTAssertEqual(keyFile.absoluteString, "file://foo/MasterKeyContainer")
    }
    
    func testInfoFile() {
        let infoFile = VaultResourceLocator(rootUrl).info
        
        XCTAssertEqual(infoFile.absoluteString, "file://foo/Info")
    }
    
    func testItemsDirectory() {
        let keyFile = VaultResourceLocator(rootUrl).items
        
        XCTAssertEqual(keyFile.absoluteString, "file://foo/Items/")
    }
    
    func testItemFile() throws {
        let itemFile = VaultResourceLocator(rootUrl).item()
        
        let itemID = try XCTUnwrap(UUID(uuidString: itemFile.lastPathComponent))
        XCTAssertEqual(itemFile.absoluteString, "file://foo/Items/\(itemID.uuidString)")
    }
    
}

