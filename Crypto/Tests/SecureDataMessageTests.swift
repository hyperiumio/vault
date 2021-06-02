import CryptoKit
import XCTest
@testable import Crypto

class SecureDataMessageTests: XCTestCase {
    
    func testInitNonceCiphertextTag() {
        let nonce = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B
        ] as Data
        let ciphertext = [
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
        ] as Data
        let tag = [
            0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27
        ] as Data
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        XCTAssertEqual(message.nonce, nonce)
        XCTAssertEqual(message.ciphertext, ciphertext)
        XCTAssertEqual(message.tag, tag)
    }
    
    func testDecryptSuccess() throws {
        let nonce = [
            0xB1, 0x46, 0xF7, 0xB2, 0xF8, 0x11, 0x8E, 0x14,
            0x08, 0xB2, 0x59, 0x98
        ] as Data
        let ciphertext = [
            0x49, 0xCD, 0xCE, 0x2D, 0x97, 0xCB, 0x9C, 0xB6
        ] as Data
        let tag = [
            0xD5, 0x88, 0x76, 0x59, 0x75, 0x8D, 0x01, 0x6A,
            0xAE, 0xA9, 0x13, 0xCB, 0xBF, 0x0E, 0x7D, 0x74
        ] as Data
        let messageKey = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as MessageKey
        let expectedPlaintext = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
        ] as Data
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let plaintext = try message.decrypt(using: messageKey)
        
        XCTAssertEqual(plaintext, expectedPlaintext)
    }
    
    func testDecryptInvalidNonce() {
        let nonce = [] as Data
        let ciphertext = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
        ] as Data
        let tag = [
            0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
        ] as Data
        let messageKey = [
            0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
            0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
            0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37
        ] as MessageKey
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        XCTAssertThrowsError(try message.decrypt(using: messageKey))
    }
    
    func testDecryptInvalidTag() {
        let nonce = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B
        ] as Data
        let ciphertext = [
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
        ] as Data
        let tag = [] as Data
        let messageKey = [
            0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
            0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
            0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37
        ] as MessageKey
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        XCTAssertThrowsError(try message.decrypt(using: messageKey))
    }
    
    func testDecryptInvalidMessageKey() {
        let nonce = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B
        ] as Data
        let ciphertext = [
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
        ] as Data
        let tag = [
            0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27
        ] as Data
        let messageKey = [] as MessageKey
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        XCTAssertThrowsError(try message.decrypt(using: messageKey))
    }
    
    func testEncryptContainerSuccess() throws {
        let messages = [
            [
                0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
            ]
        ] as [Data]
        let masterKey = MasterKey()
        let container = try SecureDataMessage.encryptContainer(from: messages, using: masterKey)
        let expectedLength = 4 + 4 + 60 + 16 + 12 + 8
        
        XCTAssertEqual(container.count, expectedLength)
    }
    
    func testEncryptContainerMessageEncryptionFailure() {
        let messages = [[]] as [Data]
        let masterKey = MasterKey()
        let cryptor = CryptorStub(encryptionResult: nil, authenticationEncryptionResult: nil)
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testEncryptContainerKeyWrappingFailure() {
        let messages = [[]] as [Data]
        let masterKey = MasterKey()
        let encryptionResult = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00
        ] as AES.GCM.SealedBox
        let cryptor = CryptorStub(encryptionResult: encryptionResult, authenticationEncryptionResult: nil)
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testEncryptContainerInvalidKeyWrap() throws {
        let messages = [[]] as [Data]
        let masterKey = MasterKey()
        let encryptionResult = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00
        ] as  AES.GCM.SealedBox
        let nonce = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
        ] as AES.GCM.Nonce
        let ciphertext = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as Data
        let tag = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as Data
        let authenticationEncryptionResult = try? AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let cryptor = CryptorStub(encryptionResult: encryptionResult, authenticationEncryptionResult: authenticationEncryptionResult)
        
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testDecryptMessagesSuccess() throws {
        let container = [
            0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
            0x14, 0x6A, 0xF5, 0xCF, 0x0B, 0x9C, 0x64, 0x92,
            0x43, 0x05, 0xAF, 0xD4, 0x3A, 0x99, 0x9B, 0xD7,
            0x74, 0xFC, 0x02, 0xD0, 0x08, 0x55, 0xED, 0x02,
            0x02, 0x19, 0xB3, 0x32, 0x02, 0xFC, 0xE8, 0xF0,
            0xEF, 0x03, 0x15, 0x7A, 0x49, 0xB2, 0x56, 0x8C,
            0x0C, 0x81, 0x94, 0x52, 0xE0, 0x00, 0xFD, 0x7D,
            0x36, 0x82, 0xD1, 0xE7, 0x15, 0x9B, 0x9D, 0xFB,
            0x92, 0xCD, 0xA3, 0xC0, 0x7F, 0xDF, 0xE1, 0xB6,
            0x0E, 0x6D, 0xB1, 0x33, 0x60, 0x85, 0x9E, 0x49,
            0xF4, 0x9E, 0x82, 0xE6, 0xE8, 0xC4, 0x42, 0xD2,
            0xBE, 0x80, 0x9C, 0xC2, 0xFB, 0xCF, 0x56, 0xBA,
            0x25, 0xC2, 0x67, 0x1F, 0x60, 0x62, 0x38, 0x04,
            0x5C, 0xF9, 0x5E, 0xBD, 0x78, 0x8C, 0x8B, 0xA6,
            0x14, 0x74, 0xBD, 0x03, 0xD5, 0x4D, 0x72, 0x7F,
            0x61, 0xF5, 0x5D, 0x10, 0x13, 0x20, 0xB7, 0x70,
            0xDD, 0x44, 0x18, 0x8A, 0xF9, 0x04, 0xB1, 0x4D,
            0xD9, 0x25, 0x01, 0x80, 0x96, 0xD4, 0x97, 0x99,
            0x54, 0x47, 0x83, 0x1A, 0x4A, 0x79, 0x00, 0x36,
            0x0A, 0xC1, 0xA3, 0x3E, 0x20, 0xC4, 0x6E, 0x90,
            0x97, 0xED, 0x31, 0xB6, 0x7C, 0x24, 0xA5, 0x6E,
            0x42, 0x48, 0x7C, 0x77, 0xC5, 0x97, 0xA7, 0xF7,
            0xD1, 0xC4, 0x96, 0x71, 0xAD, 0xB7, 0xFF, 0x56,
            0xCE, 0xDC, 0xA3, 0x7C, 0x88, 0xDF, 0xC4, 0x0E,
            0xCC, 0xFF, 0x9F, 0x0A, 0x65, 0xBB, 0xBC, 0x9C,
            0x32, 0xC1, 0xE0, 0x7D, 0xC1, 0xD7, 0xFD, 0x9E,
            0x83, 0x41, 0xC4, 0x99, 0xBB, 0x08, 0x08, 0x3D,
            0x22, 0x65, 0x70, 0x4D, 0xA1, 0x9D, 0x30, 0x79,
            0x0A, 0x01, 0xB7, 0x8D, 0x6D, 0xE5, 0x30, 0x22,
            0x83, 0xC8, 0x58, 0x0E, 0x7E, 0xBB, 0x65, 0x29,
            0xE4, 0x8E, 0xD0, 0x10, 0x65, 0x8A, 0x96, 0x40,
            0x5F, 0x87, 0xBF, 0x9F, 0xB8, 0x34, 0xF0, 0x87,
            0xFF, 0x2A, 0x11, 0x00, 0x3D, 0x63, 0x33, 0xB7,
            0x4B, 0x93, 0xFF, 0x28, 0x1A, 0xC1, 0xC8, 0x12,
            0x0E, 0x27, 0xA3, 0x6B, 0x3E, 0x28, 0xE1, 0x25,
            0xB4, 0xBB, 0xEA, 0x78, 0x8C, 0xF0, 0xF6, 0xF1,
            0x54, 0x57, 0xB4, 0x10, 0xBF, 0x76, 0xC0, 0x5B,
            0x33, 0xB8, 0xAA, 0xCF, 0x4F, 0x59, 0xA9, 0x6B,
            0x6E, 0x34, 0xC1, 0x84, 0x45, 0x9C, 0x4C, 0x8F,
            0xC3, 0x82, 0xB2, 0xF9, 0xF2, 0x67, 0xF8, 0xC6,
            0x62, 0x0E, 0x18, 0x57, 0x32, 0x65, 0xEA, 0x35,
            0x31, 0xB4, 0xC8, 0x57, 0xD3, 0x03, 0x1D, 0x00,
            0xEB, 0x24, 0xD0, 0x71, 0x16, 0xCE, 0x16, 0xB4,
            0x29, 0x20, 0x00, 0x60, 0x43, 0x7D, 0x5C, 0x5F
        ] as Data
        let masterKey = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as MasterKey
        let expectedMessages = [
            Data(0...UInt8.max)
        ]
        
        let messages = try SecureDataMessage.decryptMessages(from: container, using: masterKey)
        
        XCTAssertEqual(messages, expectedMessages)
    }
    
    func testDecryptMessagesInvalidContainer() {
        let container = [] as Data
        let key = MasterKey()
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: container, using: key))
    }
    
    func testDecryptMessagesInvalidMasterKey() {
        let container = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as Data
        let masterKey = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as MasterKey
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: container, using: masterKey))
    }
    
    func testDecryptMessagesInvalidMessageKey() {
        let masterKey = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ] as MasterKey
        let manipulatedContainer = [
            0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xE6, 0x47, 0x33, 0x2A, 0xAE, 0x0E, 0xBB, 0x59,
            0x86, 0xCC, 0xD8, 0x90, 0xE6, 0x09, 0x04, 0x12,
            0x05, 0x69, 0xFE, 0xAF, 0xCF, 0x3C, 0xCE, 0xF3,
            0xA7, 0xC3, 0x7D, 0xDE, 0x9B, 0x35, 0x21, 0xF8,
            0x1F, 0x66, 0x5A, 0xD7, 0x7D, 0x9A, 0x58, 0x82,
            0x15, 0x9E, 0xD8, 0xCE, 0xF6, 0x7E, 0x50, 0xFC,
            0xEC, 0x1E, 0xD1, 0x47, 0x03, 0x2A, 0x93, 0x7E,
            0x3C, 0xEA, 0xC3, 0x8E, 0x23, 0x05, 0xAC, 0xC0,
            0x29, 0x26, 0xD5, 0x6A, 0x6E, 0x05, 0xD0, 0x0C,
            0x5E, 0x1D, 0x09, 0x6D, 0xB2, 0xA0, 0x7F, 0x1C,
            0x29, 0xA3, 0x9B, 0xA2, 0x1D, 0xF8, 0xAE, 0xDD
        ] as Data
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: manipulatedContainer, using: masterKey))
        
        for n in manipulatedContainer {
            print("0x" + String(format:"%02X", n))
        }
        
    }
    
}
