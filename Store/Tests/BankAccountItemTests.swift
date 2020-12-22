import XCTest
@testable import Storage

class BankAccountItemTests: XCTestCase {
    
    func testInitFromValues() {
        let item = BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz")
        
        XCTAssertEqual(item.accountHolder, "foo")
        XCTAssertEqual(item.iban, "bar")
        XCTAssertEqual(item.bic, "baz")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "accountHolder": "foo",
          "iban": "bar",
          "bic": "baz"
        }
        """.data(using: .utf8)!
        
        let item = try BankAccountItem(from: data)
        
        XCTAssertEqual(item.accountHolder, "foo")
        XCTAssertEqual(item.iban, "bar")
        XCTAssertEqual(item.bic, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
        XCTAssertThrowsError(try BankAccountItem(from: data))
    }
    
    func testType() {
        let item = BankAccountItem(accountHolder: "", iban: "", bic: "")
        
        XCTAssertEqual(item.secureItemType, .bankAccount)
        XCTAssertEqual(BankAccountItem.secureItemType, .bankAccount)
    }
    
    func testEncoded() throws {
        let item = try BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let accountHolder = try XCTUnwrap(json["accountHolder"] as? String)
        let iban = try XCTUnwrap(json["iban"] as? String)
        let bic = try XCTUnwrap(json["bic"] as? String)
        
        XCTAssertEqual(json.count, 3)
        XCTAssertEqual(accountHolder, "foo")
        XCTAssertEqual(iban, "bar")
        XCTAssertEqual(bic, "baz")
    }
    
}
