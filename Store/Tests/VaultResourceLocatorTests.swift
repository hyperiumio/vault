import XCTest
@testable import Store

class VaultResourceLocatorTests: XCTestCase {
    
    let rootUrl = URL(string: "file://foo")!
    
    func testInit() {
        let rootDirectory = VaultResourceLocator(rootUrl).rootDirectory
        
        XCTAssertEqual(rootDirectory.absoluteString, "file://foo")
    }
    
    func testKeyFile() {
        let keyFile = VaultResourceLocator(rootUrl).keyFile
        
        XCTAssertEqual(keyFile.absoluteString, "file://foo/key")
    }
    
    func testInfoFile() {
        let infoFile = VaultResourceLocator(rootUrl).infoFile
        
        XCTAssertEqual(infoFile.absoluteString, "file://foo/info")
    }
    
    func testItemsDirectory() {
        let keyFile = VaultResourceLocator(rootUrl).itemsDirectory
        
        XCTAssertEqual(keyFile.absoluteString, "file://foo/items/")
    }
    
    func testItemFile() throws {
        let itemFile = VaultResourceLocator(rootUrl).itemFile()
        
        let itemID = try XCTUnwrap(UUID(uuidString: itemFile.lastPathComponent))
        XCTAssertEqual(itemFile.absoluteString, "file://foo/items/\(itemID.uuidString)")
    }
    
}

