import CryptoKit
import XCTest
@testable import Crypto

class SecureDataHeaderTests: XCTestCase {
    
    func testInitWithItemsEncryptedByWrappedItemKey() {
        let tag = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
        ] as Data
        let elements = [
            SecureDataHeader.Element(nonceRange: 0..<2, ciphertextRange: 2..<4, tag: tag)
        ]
        let wrappedMessageKey = [
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
            0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
            0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
            0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
            0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F,
            0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
            0x48, 0x49, 0x4A, 0x4B
        ] as Data
        let header = SecureDataHeader(with: elements, encryptedBy: wrappedMessageKey)
        
        XCTAssertEqual(header.elements, elements)
        XCTAssertEqual(header.wrappedMessageKey, wrappedMessageKey)
    }
    
    /*
    func testInitFromDataSuccess() throws {
        let messageCount = [1, 0, 0, 0] as Data
        let ciphertextSizes = [UInt8.max, 0, 0, 0] as Data
        let wrappedKey = Data(repeating: 2, count: 60)
        let tags = Data(repeating: 3, count: 16)
        let secureData = messageCount + ciphertextSizes + wrappedKey + tags
        let header = try SecureDataHeader(data: secureData)
        
        XCTAssertEqual(header.wrappedMessageKey, wrappedKey)
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
 */
    
}
