import XCTest
@testable import Crypto

/*
class MasterKeyTests: XCTestCase {
    
    func testInit() {
        let masterKey = MasterKey()
        
        XCTAssertEqual(masterKey.cryptoKey.bitCount, 256)
    }
    
    func testInitWithData() {
        let expectedData = Data(0 ..< 32)
        
        let cryptoKeyData = MasterKey(expectedData).cryptoKey.withUnsafeBytes { cryptoKey in
            return Data(cryptoKey)
        }
        
        XCTAssertEqual(cryptoKeyData, expectedData)
    }
    
}
*/
