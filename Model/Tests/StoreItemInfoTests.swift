import XCTest
@testable import Model

class StoreItemInfoTests: XCTestCase {
    
    func testInitFromValues() {
        let id = UUID()
        let secondaryTypes = [SecureItemType.login]
        let created = Date(timeIntervalSince1970: 0)
        let modified = Date(timeIntervalSince1970: 1)
        
        let info = StoreItemInfo(id: id, name: "foo", description: "bar", primaryType: .password, secondaryTypes: secondaryTypes, created: created, modified: modified)
        
        XCTAssertEqual(info.id, id)
        XCTAssertEqual(info.name, "foo")
        XCTAssertEqual(info.description, "bar")
        XCTAssertEqual(info.primaryType, .password)
        XCTAssertEqual(info.secondaryTypes, secondaryTypes)
        XCTAssertEqual(info.created, created)
        XCTAssertEqual(info.modified, modified)
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "id": "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A",
          "name": "foo",
          "description": "bar",
          "primaryType": "password",
          "secondaryTypes": ["login", "password", "wifi", "note", "bankCard", "bankAccount", "custom", "file"],
          "created": "1970-01-01T00:00:00Z",
          "modified": "1970-01-01T00:00:01Z"
        }
        """ as Data
        
        let info = try StoreItemInfo(from: data)
        
        XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
        XCTAssertEqual(info.name, "foo")
        XCTAssertEqual(info.description, "bar")
        XCTAssertEqual(info.primaryType, .password)
        XCTAssertEqual(info.secondaryTypes, [.login, .password, .wifi, .note, .bankCard, .bankAccount, .custom, .file])
        XCTAssertEqual(info.created, ISO8601DateFormatter().date(from: "1970-01-01T00:00:00Z"))
        XCTAssertEqual(info.modified, ISO8601DateFormatter().date(from: "1970-01-01T00:00:01Z"))
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try StoreItemInfo(from: data))
    }
    
    func testEncoded() throws {
        let expectedID = UUID()
        let expectedSecondaryTypes = [.login, .password, .wifi, .note, .bankCard, .bankAccount, .custom, .file] as [SecureItemType]
        let expectedCreated = Date(timeIntervalSince1970: 0)
        let expectedModified = Date(timeIntervalSince1970: 1)
        
        let info = try StoreItemInfo(id: expectedID, name: "foo", description: "bar", primaryType: .password, secondaryTypes: expectedSecondaryTypes, created: expectedCreated, modified: expectedModified).encoded
        let json = try JSONSerialization.jsonObject(with: info) as! [String: Any]
        let id = json["id"] as! String
        let name = json["name"] as! String
        let description = json["description"] as! String
        let primaryType = json["primaryType"] as! String
        let secondaryTypes = json["secondaryTypes"] as! [String]
        let created = json["created"] as! String
        let modified = json["modified"] as! String
        
        XCTAssertEqual(json.count, 7)
        XCTAssertEqual(id, expectedID.uuidString)
        XCTAssertEqual(name, "foo")
        XCTAssertEqual(description, "bar")
        XCTAssertEqual(primaryType, "password")
        XCTAssertEqual(secondaryTypes, ["login", "password", "wifi", "note", "bankCard", "bankAccount", "custom", "file"])
        XCTAssertEqual(created, "1970-01-01T00:00:00Z")
        XCTAssertEqual(modified, "1970-01-01T00:00:01Z")
    }
    
}
