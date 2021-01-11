import XCTest
@testable import Storage

class BankCardItemTests: XCTestCase {

    func testInitFromValues() {
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
        """.data(using: .utf8)!
        
        let item = try BankCardItem(from: data)
        
        XCTAssertEqual(item.name, "foo")
        XCTAssertEqual(item.number, "bar")
        XCTAssertEqual(item.expirationDate, ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z"))
        XCTAssertEqual(item.pin, "baz")
    }
    
    func testInitFromInvalidData() {
        let data = "".data(using: .utf8)!
        
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
        let item = try BankCardItem(name: "foo", number: "bar", expirationDate: .distantPast, pin: "baz").encoded()
        let json = try XCTUnwrap(try JSONSerialization.jsonObject(with: item) as? [String: Any])
        
        let name = try XCTUnwrap(json["name"] as? String)
        let number = try XCTUnwrap(json["number"] as? String)
        let expirationDate = try XCTUnwrap(json["expirationDate"] as? String)
        let pin = try XCTUnwrap(json["pin"] as? String)
        
        XCTAssertEqual(json.count, 4)
        XCTAssertEqual(name, "foo")
        XCTAssertEqual(number, "bar")
        XCTAssertEqual(ISO8601DateFormatter().date(from: expirationDate), .distantPast)
        XCTAssertEqual(pin, "baz")
    }
    
}
