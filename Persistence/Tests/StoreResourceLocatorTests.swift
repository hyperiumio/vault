import XCTest
@testable import Persistence

class StoreResourceLocatorTests: XCTestCase {
    
    let storeURL = URL(string: "file://foo/bar")!
    
    func testInit() {
        let locator = StoreResourceLocator(storeURL: storeURL)
        
        XCTAssertEqual(locator.storeURL.absoluteString, "file://foo/bar")
    }
    
    func testInfoURL() {
        let locator = StoreResourceLocator(storeURL: storeURL)
        
        XCTAssertEqual(locator.infoURL.absoluteString, "file://foo/bar/Info.json")
    }
    
    func testDerivedKeyContainerURL() {
        let locator = StoreResourceLocator(storeURL: storeURL)
        
        XCTAssertEqual(locator.derivedKeyContainerURL.absoluteString, "file://foo/bar/DerivedKeyContainer")
    }
    
    func testMasterKeyContainerURL() {
        let locator = StoreResourceLocator(storeURL: storeURL)
        
        XCTAssertEqual(locator.masterKeyContainerURL.absoluteString, "file://foo/bar/MasterKeyContainer")
    }
    
    func testItemsURL() {
        let locator = StoreResourceLocator(storeURL: storeURL)
        
        XCTAssertEqual(locator.itemsURL.absoluteString, "file://foo/bar/Items/")
    }
    
    func testGenerateItemURL() throws {
        let item = StoreResourceLocator(storeURL: storeURL).generateItemURL()
        
        let itemID = try XCTUnwrap(UUID(uuidString: item.lastPathComponent))
        XCTAssertEqual(item.absoluteString, "file://foo/bar/Items/\(itemID.uuidString)")
    }
    
    func testGenerateStoreResourceLocator() {
        let expectedContainerURL = URL(string: "file://foo")!
        let locator = StoreResourceLocator.generate(in: expectedContainerURL)
        let containerURL = locator.storeURL.deletingLastPathComponent()
        let storeID = UUID(uuidString: locator.storeURL.lastPathComponent)
        
        XCTAssertEqual(containerURL.absoluteString, "file://foo/")
        XCTAssertNotNil(storeID)
    }
    
}
