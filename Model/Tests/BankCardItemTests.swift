import XCTest
@testable import Model

class BankCardItemTests: XCTestCase {

    func testInitNameNumberExpirationDatePin() {
        let item = BankCardItem(name: "foo", number: "bar", expirationDate: .distantPast, pin: "baz")
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.number, "bar")
        XCTAssertEqual(item.expirationDate, .distantPast)
        XCTAssertEqual(item.pin, "baz")
    }
    
    func testInitFromData() throws {
        let data = """
        {
          "name": "foo",
          "number": "bar",
          "expirationDate": "2020-10-07T14:35:50Z",
          "pin": "baz"
        }
        """ as Data
        let expectedExpirationDate = ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z")
        let item = try BankCardItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.number, "bar")
        XCTAssertEqual(item.expirationDate, expectedExpirationDate)
        XCTAssertEqual(item.pin, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "" as Data
        
        XCTAssertThrowsError(try BankCardItem(from: data))
    }
    
    func testVendor() {
        let mastercard = BankCardItem(number: "5").vendor
        let visa = BankCardItem(number: "4").vendor
        let americanExpress = BankCardItem(number: "38").vendor
        let other = BankCardItem(number: "0").vendor
        let none = BankCardItem().vendor
        
        XCTAssertEqual(mastercard, .masterCard)
        XCTAssertEqual(visa, .visa)
        XCTAssertEqual(americanExpress, .americanExpress)
        XCTAssertNil(other)
        XCTAssertNil(none)
    }
    
    func testSecureItemType() {
        let item = BankCardItem(name: "", number: "", expirationDate: .distantPast, pin: "")
        
        XCTAssertEqual(item.secureItemType, .bankCard)
        XCTAssertEqual(BankCardItem.secureItemType, .bankCard)
    }
    
    func testEncoded() throws {
        let expirationDate = ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z")
        let item = try BankCardItem(name: "foo", number: "bar", expirationDate: expirationDate, pin: "baz").encoded
        let json = try JSONSerialization.jsonObject(with: item) as! [String: String]
        let expectedJson = [
            "name": "foo",
            "number": "bar",
            "expirationDate": "2020-10-07T14:35:50Z",
            "pin": "baz"
        ]
        
        XCTAssertEqual(json, expectedJson)
    }
    
}
