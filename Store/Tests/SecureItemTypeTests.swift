import XCTest
@testable import Store

class SecureItemTypeTests: XCTestCase {
    
    func testSecureItemTypeIdentifierId() {
        XCTAssertEqual(SecureItemType.password.id, .password)
        XCTAssertEqual(SecureItemType.login.id, .login)
        XCTAssertEqual(SecureItemType.file.id, .file)
        XCTAssertEqual(SecureItemType.note.id, .note)
        XCTAssertEqual(SecureItemType.bankCard.id, .bankCard)
        XCTAssertEqual(SecureItemType.wifi.id, .wifi)
        XCTAssertEqual(SecureItemType.bankAccount.id, .bankAccount)
        XCTAssertEqual(SecureItemType.custom.id, .custom)
    }
    
}
