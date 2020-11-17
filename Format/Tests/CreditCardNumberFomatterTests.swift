import XCTest
@testable import Format

final class CreditCardNumberFomatterTests: XCTestCase {
    
    func testStringForObjectInvalidInputType() {
        let output = CreditCardNumberFormatter().string(for: 0)
        
        XCTAssertNil(output)
    }
    
    func testStringForObjectValidInput() {
        let output = CreditCardNumberFormatter().string(for: "111122")
        
        XCTAssertEqual(output, "1111 22")
    }
    
    func testGetObjectValueValidInput() {
        var output = nil as AnyObject?
        let success = CreditCardNumberFormatter().getObjectValue(&output, for: "1111 22", errorDescription: nil)
        
        XCTAssertTrue(success)
        XCTAssertEqual(output as? String, "111122")
    }
}
