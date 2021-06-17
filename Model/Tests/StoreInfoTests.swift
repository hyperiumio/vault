import XCTest
@testable import Model

class StoreInfoTests: XCTestCase {
    
    func testInit() {
        let info = StoreInfo()
        
        XCTAssertEqual(info.keyVersion, 1)
        XCTAssertEqual(info.itemVersion, 1)
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "keyVersion": 1,
          "itemVersion": 1,
          "id": "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A",
          "created": "2020-10-07T14:35:50Z"
        }
        """ as Data
        
        let info = try StoreInfo(from: data)
        
        XCTAssertEqual(info.keyVersion, 1)
        XCTAssertEqual(info.itemVersion, 1)
        XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
        XCTAssertEqual(info.created, ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z"))
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try StoreInfo(from: data))
    }
    
    func testEncoded() throws {
        let info = try StoreInfo().encoded
        let json = try JSONSerialization.jsonObject(with: info) as! [String: Any]
        
        let keyVersion = json["keyVersion"] as! Int
        let itemVersion = json["itemVersion"] as! Int
        let id = json["id"] as! String
        let createdAt = json["created"] as! String
        
        XCTAssertEqual(keyVersion, 1)
        XCTAssertEqual(itemVersion, 1)
        XCTAssertNotNil(UUID(uuidString: id))
        XCTAssertNotNil(ISO8601DateFormatter().date(from: createdAt))
    }
    
}
