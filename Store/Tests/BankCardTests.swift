import XCTest
@testable import Store

class BankCardTests: XCTestCase {

    func testInit() {
        let item = BankCardItem(name: "foo", number: "bar", expirationDate: .distantPast, pin: "baz")
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.number, "bar")
        XCTAssertEqual(item.expirationDate, .distantPast)
        XCTAssertEqual(item.pin, "baz")
    }
    
    func testVendor() {
        let mastercard = BankCardItem(name: "", number: "5", expirationDate: .distantPast, pin: "").vendor
        let visa = BankCardItem(name: "", number: "4", expirationDate: .distantPast, pin: "").vendor
        let americanExpress = BankCardItem(name: "", number: "38", expirationDate: .distantPast, pin: "").vendor
        let other = BankCardItem(name: "", number: "0", expirationDate: .distantPast, pin: "").vendor
        
        XCTAssertEqual(mastercard, .masterCard)
        XCTAssertEqual(visa, .visa)
        XCTAssertEqual(americanExpress, .americanExpress)
        XCTAssertEqual(other, .other)
    }
    
}
