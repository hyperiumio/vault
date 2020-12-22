import XCTest
@testable import Storage

class StoreResourceLocatorTests: XCTestCase {
    
    let rootUrl = URL(string: "file://foo/bar")!
    
    func testInit() {
        let rootDirectory = StoreResourceLocator(rootUrl).rootDirectory
        
        XCTAssertEqual(rootDirectory.absoluteString, "file://foo/bar")
    }
    
    func testContainer() {
        let container = StoreResourceLocator(rootUrl).container
        
        XCTAssertEqual(container.absoluteString, "file://foo/")
    }
    
    func testKeyFile() {
        let key = StoreResourceLocator(rootUrl).key
        
        XCTAssertEqual(key.absoluteString, "file://foo/bar/Key")
    }
    
    func testInfoFile() {
        let info = StoreResourceLocator(rootUrl).info
        
        XCTAssertEqual(info.absoluteString, "file://foo/bar/Info.json")
    }
    
    func testItemsDirectory() {
        let items = StoreResourceLocator(rootUrl).items
        
        XCTAssertEqual(items.absoluteString, "file://foo/bar/Items/")
    }
    
    func testItemFile() throws {
        let item = StoreResourceLocator(rootUrl).item()
        
        let itemID = try XCTUnwrap(UUID(uuidString: item.lastPathComponent))
        XCTAssertEqual(item.absoluteString, "file://foo/bar/Items/\(itemID.uuidString)")
    }
    
}

