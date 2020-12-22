import XCTest
@testable import Store

class VaultResourceLocatorTests: XCTestCase {
    
    let rootUrl = URL(string: "file://foo/bar")!
    
    func testInit() {
        let rootDirectory = VaultResourceLocator(rootUrl).rootDirectory
        
        XCTAssertEqual(rootDirectory.absoluteString, "file://foo/bar")
    }
    
    func testContainer() {
        let container = VaultResourceLocator(rootUrl).container
        
        XCTAssertEqual(container.absoluteString, "file://foo/")
    }
    
    func testKeyFile() {
        let key = VaultResourceLocator(rootUrl).key
        
        XCTAssertEqual(key.absoluteString, "file://foo/bar/Key")
    }
    
    func testInfoFile() {
        let info = VaultResourceLocator(rootUrl).info
        
        XCTAssertEqual(info.absoluteString, "file://foo/bar/Info.json")
    }
    
    func testItemsDirectory() {
        let items = VaultResourceLocator(rootUrl).items
        
        XCTAssertEqual(items.absoluteString, "file://foo/bar/Items/")
    }
    
    func testItemFile() throws {
        let item = VaultResourceLocator(rootUrl).item()
        
        let itemID = try XCTUnwrap(UUID(uuidString: item.lastPathComponent))
        XCTAssertEqual(item.absoluteString, "file://foo/bar/Items/\(itemID.uuidString)")
    }
    
}

