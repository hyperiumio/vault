import XCTest
@testable import Format

final class BankAccountNumberFormatStyleTests: XCTestCase {
    
    func testFormat() {
        let output = BankAccountNumberFormatStyle().format("DE1122")
        
        XCTAssertEqual(output, "DE11 22")
        XCTAssertThrowsError(try await foo())
    }
    
    func testParse() {
        let output = BankAccountNumberFormatStyle().parse("DE11 22")
        
        XCTAssertEqual(output, "DE1122")
    }
    
}

func foo() async throws {
    
}
