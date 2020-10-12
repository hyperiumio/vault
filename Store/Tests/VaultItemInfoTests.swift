import Foundation
import XCTest
@testable import Store

class VaultItemInfoTests: XCTestCase {
    
    func testInitFromValues() {
        let id = UUID()
        let secondaryTypes = [SecureItemType.login]
        let created = Date(timeIntervalSince1970: 0)
        let modified = Date(timeIntervalSince1970: 1)
        
        let info = VaultItemInfo(id: id, name: "foo", description: "bar", primaryType: .password, secondaryTypes: secondaryTypes, created: created, modified: modified)
        
        XCTAssertEqual(info.id, id)
        XCTAssertEqual(info.name, "foo")
        XCTAssertEqual(info.description, "bar")
        XCTAssertEqual(info.primaryType, .password)
        XCTAssertEqual(info.secondaryTypes, secondaryTypes)
        XCTAssertEqual(info.created, created)
        XCTAssertEqual(info.modified, modified)
    }
    
    func testInitFromValuesNilValues() {
        let id = UUID()
        
        let info = VaultItemInfo(id: id, name: "", description: nil, primaryType: .password, secondaryTypes: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertNil(info.description)
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
        """.data(using: .utf8)!
        
        let info = try VaultItemInfo(from: data)
        
        XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
        XCTAssertEqual(info.name, "foo")
        XCTAssertEqual(info.description, "bar")
        XCTAssertEqual(info.primaryType, .password)
        XCTAssertEqual(info.secondaryTypes, [.login, .password, .wifi, .note, .bankCard, .bankAccount, .custom, .file])
        XCTAssertEqual(info.created, ISO8601DateFormatter().date(from: "1970-01-01T00:00:00Z"))
        XCTAssertEqual(info.modified, ISO8601DateFormatter().date(from: "1970-01-01T00:00:01Z"))
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try VaultItemInfo(from: data))
    }
    
    func testEncoded() throws {
        let expectedID = UUID()
        let expectedSecondaryTypes = [.login, .password, .wifi, .note, .bankCard, .bankAccount, .custom, .file] as [SecureItemType]
        let expectedCreated = Date(timeIntervalSince1970: 0)
        let expectedModified = Date(timeIntervalSince1970: 1)
        
        let info = try VaultItemInfo(id: expectedID, name: "foo", description: "bar", primaryType: .password, secondaryTypes: expectedSecondaryTypes, created: expectedCreated, modified: expectedModified).encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: info) as? [String: Any])
        
        let id = try XCTUnwrap(json["id"] as? String)
        let name = try XCTUnwrap(json["name"] as? String)
        let description = try XCTUnwrap(json["description"] as? String)
        let primaryType = try XCTUnwrap(json["primaryType"] as? String)
        let secondaryTypes = try XCTUnwrap(json["secondaryTypes"] as? [String])
        let created = try XCTUnwrap(json["created"] as? String)
        let modified = try XCTUnwrap(json["modified"] as? String)
        
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
