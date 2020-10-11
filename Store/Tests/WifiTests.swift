import XCTest
@testable import Store

class WifiTests: XCTestCase {
    
    func testInitFromValues() {
        let item = WifiItem(networkName: "foo", networkPassword: "bar")
        
        XCTAssertEqual(item.networkName, "foo")
        XCTAssertEqual(item.networkPassword, "bar")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "networkName": "foo",
          "networkPassword": "bar"
        }
        """.data(using: .utf8)!
        
        let item = try WifiItem(from: data)
        
        XCTAssertEqual(item.networkName, "foo")
        XCTAssertEqual(item.networkPassword, "bar")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try WifiItem(from: data))
    }
    
    func testType() {
        let item = WifiItem(networkName: "", networkPassword: "")
        
        XCTAssertEqual(item.type, .wifi)
    }
    
    func testEncoded() throws {
        let item = try WifiItem(networkName: "foo", networkPassword: "bar").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let networkName = try XCTUnwrap(json["networkName"] as? String)
        let networkPassword = try XCTUnwrap(json["networkPassword"] as? String)
        
        XCTAssertEqual(json.count, 2)
        XCTAssertEqual(networkName, "foo")
        XCTAssertEqual(networkPassword, "bar")
    }
    
}
