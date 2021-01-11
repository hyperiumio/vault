import CryptoKit
import XCTest
@testable import Crypto

class SecureDataHeaderTests: XCTestCase {
    
    func testInit() {
        let header = SecureDataHeader(elements: [], wrappedItemKey: Data())
        
        XCTAssertEqual(header.elements.count, 0)
        XCTAssertEqual(header.wrappedItemKey, Data())
    }
    
    func testInitFromDataSuccess() throws {
        let prefix = [UInt8.max] as [UInt8]
        let messageCount = [1, 0, 0, 0] as [UInt8]
        let ciphertextSizes = [UInt8.max, 0, 0, 0] as [UInt8]
        let wrappedKey = Data(repeating: 2, count: 60)
        let tags = Data(repeating: 3, count: 16)
        let chunk = Data(prefix + messageCount + ciphertextSizes + wrappedKey + tags)
        let secureData = chunk[1...]
        
        let header = try SecureDataHeader(data: secureData)
        
        XCTAssertEqual(header.wrappedItemKey, wrappedKey)
        XCTAssertEqual(header.elements.count, 1)
        XCTAssertEqual(header.elements.first?.nonceRange, 84 ..< 96)
        XCTAssertEqual(header.elements.first?.ciphertextRange, 96 ..< 351)
        XCTAssertEqual(header.elements.first?.tag, tags)
    }
    
    func testInitFromDataInvalidDataSize() {
        let secureData = Data()
        
        XCTAssertThrowsError(try SecureDataHeader(data: secureData))
    }
    
    func testInitFromDataProviderSuccess() throws {
        let messageCount = [1, 0, 0, 0] as [UInt8]
        let ciphertextSizes = [UInt8.max, 0, 0, 0] as [UInt8]
        let wrappedKey = Data(repeating: 2, count: 60)
        let tags = Data(repeating: 3, count: 16)
        let secureData = Data(messageCount + ciphertextSizes + wrappedKey + tags)
        
        let header = try SecureDataHeader { range in
            secureData[range]
        }
        
        XCTAssertEqual(header.wrappedItemKey, wrappedKey)
        XCTAssertEqual(header.elements.count, 1)
        XCTAssertEqual(header.elements.first?.nonceRange, 84 ..< 96)
        XCTAssertEqual(header.elements.first?.ciphertextRange, 96 ..< 351)
        XCTAssertEqual(header.elements.first?.tag, tags)
    }
    
    func testInitFromDataProviderMessageCountDataNotAvailable() {
        XCTAssertThrowsError(try SecureDataHeader { _ in
            throw CryptoError.invalidDataSize
        })
    }
    
    func testInitFromDataProviderHeaderDataNotAvailable() {
        var callIndex = 0
        
        XCTAssertThrowsError(try SecureDataHeader { _ in
            defer {
                callIndex += 1
            }
            
            switch callIndex {
            case 0:
                return Data([1, 0, 0, 0])
            default:
                throw CryptoError.invalidDataSize
            }
        })
    }
    
    func testUnwrapKeySuccess() throws {
        let key = MasterKey(Data(0 ..< 32))
        let message = [1, 0, 0, 0, 9, 0, 0, 0, 103, 20, 24, 195, 10, 172, 111, 110, 93, 193, 247, 247, 43, 226, 30, 158, 57, 117, 32, 224, 37, 2, 211, 7, 195, 73, 198, 122, 47, 179, 2, 210, 117, 72, 197, 200, 153, 61, 244, 18, 87, 74, 60, 198, 136, 174, 74, 196, 144, 67, 249, 166, 227, 148, 134, 196, 95, 165, 249, 216, 12, 68, 242, 82, 231, 65, 114, 150, 51, 165, 246, 108, 3, 157, 31, 163, 49, 88, 124, 150, 118, 170, 95, 46, 41, 253, 98, 203, 218, 84, 162, 16, 39, 222, 181, 90, 105] as [UInt8]
        let itemKey = try SecureDataHeader(data: Data(message)).unwrapKey(with: key)
        let expectedKeyBytes = [71, 243, 126, 209, 2, 41, 252, 15, 204, 184, 231, 12, 150, 227, 53, 194, 3, 140, 52, 173, 215, 235, 202, 100, 78, 203, 135, 200, 167, 63, 244, 239] as [UInt8]
        let expectedKey = SymmetricKey(data: expectedKeyBytes)
              
        XCTAssertEqual(itemKey.value, expectedKey)
    }
 
    
    func testUnwrapKeyInvalidItemKeySize() {
        let header = SecureDataHeader(elements: [], wrappedItemKey: Data())
        let masterKey = MasterKey()
        
        XCTAssertThrowsError(try header.unwrapKey(with: masterKey))
    }
    
    func testUnwrapKeyInvalidItemKey() throws {
        let key = MasterKey(Data(0 ..< 32))
        let message = [1, 0, 0, 0, 9, 0, 0, 0, UInt8.max, 20, 24, 195, 10, 172, 111, 110, 93, 193, 247, 247, 43, 226, 30, 158, 57, 117, 32, 224, 37, 2, 211, 7, 195, 73, 198, 122, 47, 179, 2, 210, 117, 72, 197, 200, 153, 61, 244, 18, 87, 74, 60, 198, 136, 174, 74, 196, 144, 67, 249, 166, 227, 148, 134, 196, 95, 165, 249, 216, 12, 68, 242, 82, 231, 65, 114, 150, 51, 165, 246, 108, 3, 157, 31, 163, 49, 88, 124, 150, 118, 170, 95, 46, 41, 253, 98, 203, 218, 84, 162, 16, 39, 222, 181, 90, 105] as [UInt8]
        let header = try SecureDataHeader(data: Data(message))
        
        XCTAssertThrowsError(try header.unwrapKey(with: key))
    }
    
    func testUnwrapKeyInvalidMasterKey() throws {
        let key = MasterKey(Data(repeating: 0, count: 32))
        let message = [1, 0, 0, 0, 9, 0, 0, 0, 103, 20, 24, 195, 10, 172, 111, 110, 93, 193, 247, 247, 43, 226, 30, 158, 57, 117, 32, 224, 37, 2, 211, 7, 195, 73, 198, 122, 47, 179, 2, 210, 117, 72, 197, 200, 153, 61, 244, 18, 87, 74, 60, 198, 136, 174, 74, 196, 144, 67, 249, 166, 227, 148, 134, 196, 95, 165, 249, 216, 12, 68, 242, 82, 231, 65, 114, 150, 51, 165, 246, 108, 3, 157, 31, 163, 49, 88, 124, 150, 118, 170, 95, 46, 41, 253, 98, 203, 218, 84, 162, 16, 39, 222, 181, 90, 105] as [UInt8]
        let header = try SecureDataHeader(data: Data(message))
        
        XCTAssertThrowsError(try header.unwrapKey(with: key))
    }
    
    func testUnwrapKeyInvalidTagSegment() throws {
        let key = MasterKey(Data(repeating: 0, count: 32))
        let message = [1, 0, 0, 0, 9, 0, 0, 0, 103, 20, 24, 195, 10, 172, 111, 110, 93, 193, 247, 247, 43, 226, 30, 158, 57, 117, 32, 224, 37, 2, 211, 7, 195, 73, 198, 122, 47, 179, 2, 210, 117, 72, 197, 200, 153, 61, 244, 18, 87, 74, 60, 198, 136, 174, 74, 196, 144, 67, 249, 166, 227, 148, 134, 196, 95, 165, 249, 216, UInt8.max, 68, 242, 82, 231, 65, 114, 150, 51, 165, 246, 108, 3, 157, 31, 163, 49, 88, 124, 150, 118, 170, 95, 46, 41, 253, 98, 203, 218, 84, 162, 16, 39, 222, 181, 90, 105] as [UInt8]
        let header = try SecureDataHeader(data: Data(message))
        
        XCTAssertThrowsError(try header.unwrapKey(with: key))
    }
    
}
