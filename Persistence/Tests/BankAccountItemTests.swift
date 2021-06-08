import XCTest
@testable import Persistence

class BankAccountItemTests: XCTestCase {
    
    func testInitAccountHolderIbanBic() {
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
        """ as Data
        let item = try BankAccountItem(from: data)
        
        XCTAssertEqual(item.accountHolder, "foo")
        XCTAssertEqual(item.iban, "bar")
        XCTAssertEqual(item.bic, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try BankAccountItem(from: data))
    }
    
    func testSecureItemType() {
        let item = BankAccountItem(accountHolder: "", iban: "", bic: "")
        
        XCTAssertEqual(item.secureItemType, .bankAccount)
        XCTAssertEqual(BankAccountItem.secureItemType, .bankAccount)
    }
    
    func testEncoded() throws {
        let item = try BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "accountHolder": "foo",
            "iban": "bar",
            "bic": "baz"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
