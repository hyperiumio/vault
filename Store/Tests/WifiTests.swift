import XCTest
@testable import Store

class WifiTests: XCTestCase {
    
    func testInit() {
        let item = WifiItem(networkName: "foo", networkPassword: "bar")
        
        XCTAssertEqual(item.networkName, "foo")
        XCTAssertEqual(item.networkPassword, "bar")
    }
    
}
