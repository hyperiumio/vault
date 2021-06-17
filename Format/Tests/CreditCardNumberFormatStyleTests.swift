import XCTest
@testable import Format

final class CreditCardNumberFormatStyleTests: XCTestCase {
    
    func testFormat() {
        let output = CreditCardNumberFormatStyle().format("DE1122")
        
        XCTAssertEqual(output, "DE11 22")
    }
    
    func testParse() {
        let output = CreditCardNumberFormatStyle().parse("DE11 22")
        
        XCTAssertEqual(output, "DE1122")
    }
    
}
