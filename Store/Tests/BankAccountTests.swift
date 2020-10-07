import XCTest
@testable import Store

class BankAccountTests: XCTestCase {
    
    func testInit() {
        let item = BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz")
        
        XCTAssertEqual(item.accountHolder, "foo")
        XCTAssertEqual(item.iban, "bar")
        XCTAssertEqual(item.bic, "baz")
    }
    
}
