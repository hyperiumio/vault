import CommonCrypto
import CryptoKit
import XCTest
@testable import Crypto

class MessageKeyTests: XCTestCase {
    
    func testInit() {
        let messageKey = MessageKey()
        
        XCTAssertEqual(messageKey.value.bitCount, SymmetricKeySize.bits256.bitCount)
    }
    
    func testInitFromData() {
        let keyData = Data(0 ..< 32)
        let expectedKey = SymmetricKey(data: keyData)
        let messageKey = MessageKey(keyData)
        
        XCTAssertEqual(messageKey.value, expectedKey)
    }
    
}
