import XCTest
@testable import Format

final class BankAccountNumberFormatterTests: XCTestCase {
    
    func testStringForObjectInvalidInputType() {
        let output = BankAccountNumberFormatter().string(for: 0)
        
        XCTAssertNil(output)
    }
    
    func testStringForObjectValidInput() {
        let output = BankAccountNumberFormatter().string(for: "DE1122")
        
        XCTAssertEqual(output, "DE11 22")
    }
    
    func testGetObjectValueValidInput() {
        var output = nil as AnyObject?
        let success = BankAccountNumberFormatter().getObjectValue(&output, for: "DE11 22", errorDescription: nil)
        
        XCTAssertTrue(success)
        XCTAssertEqual(output as? String, "DE1122")
    }
}
