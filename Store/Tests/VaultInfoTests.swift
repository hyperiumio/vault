import Foundation
import XCTest
@testable import Store

class VaultInfoTests: XCTestCase {
    
    func testInit() {
        let info = VaultInfo()
        
        XCTAssertEqual(info.keyVersion, 1)
        XCTAssertEqual(info.itemVersion, 1)
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "keyVersion": 1,
          "itemVersion": 1,
          "id": "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A",
          "createdAt": "2020-10-07T14:35:50Z"
        }
        """.data(using: .utf8)!
        
        let info = try VaultInfo(from: data)
        
        XCTAssertEqual(info.keyVersion, 1)
        XCTAssertEqual(info.itemVersion, 1)
        XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
        XCTAssertEqual(info.createdAt, ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z"))
    }
    
    func testEncoded() throws {
        let info = try VaultInfo().encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: info) as? [String: Any])
        
        let keyVersion = try XCTUnwrap(json["keyVersion"] as? Int)
        let itemVersion = try XCTUnwrap(json["itemVersion"] as? Int)
        let id = try XCTUnwrap(json["id"] as? String)
        let createdAt = try XCTUnwrap(json["createdAt"] as? String)
        
        XCTAssertEqual(keyVersion, 1)
        XCTAssertEqual(itemVersion, 1)
        XCTAssertNotNil(UUID(uuidString: id))
        XCTAssertNotNil(ISO8601DateFormatter().date(from: createdAt))
    }
    
}
