import CryptoKit
import XCTest
@testable import Crypto

class SecureDataMessageTests: XCTestCase {
    
    func testInit() {
        let nonce = Data(0 ..< 12)
        let ciphertext = Data(16 ..< 24)
        let tag = Data(24 ..< 40)
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        XCTAssertEqual(message.nonce, nonce)
        XCTAssertEqual(message.ciphertext, ciphertext)
        XCTAssertEqual(message.tag, tag)
    }
    
    func testDecryptSuccess() throws {
        let nonce = Data([177, 70, 247, 178, 248, 17, 142, 20, 8, 178, 89, 152])
        let ciphertext = Data([73, 205, 206, 45, 151, 203, 156, 182])
        let tag = Data([213, 136, 118, 89, 117, 141, 1, 106, 174, 169, 19, 203, 191, 14, 125, 116])
        let keyData = Data(repeating: 0, count: 32)
        let key = MessageKey(keyData)
        let plaintext = try SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag).decrypt(using: key)
        let expectedPlaintext = Data(0 ..< 8)
        
        XCTAssertEqual(plaintext, expectedPlaintext)
    }
    
    func testDecryptInvalidNonce() {
        let nonce = Data()
        let ciphertext = Data(16 ..< 24)
        let tag = Data(24 ..< 40)
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let key = MessageKey()
        
        XCTAssertThrowsError(try message.decrypt(using: key))
    }
    
    func testDecryptInvalidTag() {
        let nonce = Data(0 ..< 12)
        let ciphertext = Data(16 ..< 24)
        let tag = Data()
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let key = MessageKey()
        
        XCTAssertThrowsError(try message.decrypt(using: key))
    }
    
    func testDecryptInvalidItemKey() {
        let nonce = Data(repeating: 0, count: 12)
        let ciphertext = Data(repeating: 0, count: 8)
        let tag = Data(repeating: 0, count: 16)
        let keyData = Data()
        let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let key = MessageKey(keyData)
        
        XCTAssertThrowsError(try message.decrypt(using: key))
    }
    
    func testEncryptContainerSuccess() throws {
        let messages = [
            Data(0 ... UInt8.max)
        ]
        let masterKey = MasterKey()
        let container = try SecureDataMessage.encryptContainer(from: messages, using: masterKey)
        let expectedLength = 4 + 4 + 60 + 16 + 12 + 256
        
        XCTAssertEqual(container.count, expectedLength)
    }
    
    func testEncryptContainerMessageEncryptionFailure() {
        let messages = [
            Data()
        ]
        let masterKey = MasterKey()
        let cryptor = CryptorStub(encryptionResult: nil, authenticationEncryptionResult: nil)
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testEncryptContainerKeyWrappingFailure() {
        let messages = [
            Data()
        ]
        let masterKey = MasterKey()
        let seal = Data(repeating: 0, count: 28)
        let encryptionResult = try? AES.GCM.SealedBox(combined: seal)
        let cryptor = CryptorStub(encryptionResult: encryptionResult, authenticationEncryptionResult: nil)
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testEncryptContainerInvalidKeyWrap() throws {
        let messages = [
            Data()
        ]
        let masterKey = MasterKey()
        
        let encryptionSeal = Data(repeating: 0, count: 28)
        let encryptionResult = try? AES.GCM.SealedBox(combined: encryptionSeal)
        
        let nonceBytes = Data(0 ..< 16)
        let nonce = try AES.GCM.Nonce(data: nonceBytes)
        let ciphertext = Data(repeating: 0, count: 8)
        let tag = Data(repeating: 0, count: 16)
        let authenticationEncryptionResult = try? AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        let cryptor = CryptorStub(encryptionResult: encryptionResult, authenticationEncryptionResult: authenticationEncryptionResult)
        
        XCTAssertThrowsError(try SecureDataMessage.encryptContainer(from: messages, using: masterKey, cryptor: cryptor))
    }
    
    func testDecryptMessagesSuccess() throws {
        let keyData = Data(repeating: 0, count: 32)
        let key = MasterKey(keyData)
        let containerBytes = [1, 0, 0, 0, 0, 1, 0, 0, 20, 106, 245, 207, 11, 156, 100, 146, 67, 5, 175, 212, 58, 153, 155, 215, 116, 252, 2, 208, 8, 85, 237, 2, 2, 25, 179, 50, 2, 252, 232, 240, 239, 3, 21, 122, 73, 178, 86, 140, 12, 129, 148, 82, 224, 0, 253, 125, 54, 130, 209, 231, 21, 155, 157, 251, 146, 205, 163, 192, 127, 223, 225, 182, 14, 109, 177, 51, 96, 133, 158, 73, 244, 158, 130, 230, 232, 196, 66, 210, 190, 128, 156, 194, 251, 207, 86, 186, 37, 194, 103, 31, 96, 98, 56, 4, 92, 249, 94, 189, 120, 140, 139, 166, 20, 116, 189, 3, 213, 77, 114, 127, 97, 245, 93, 16, 19, 32, 183, 112, 221, 68, 24, 138, 249, 4, 177, 77, 217, 37, 1, 128, 150, 212, 151, 153, 84, 71, 131, 26, 74, 121, 0, 54, 10, 193, 163, 62, 32, 196, 110, 144, 151, 237, 49, 182, 124, 36, 165, 110, 66, 72, 124, 119, 197, 151, 167, 247, 209, 196, 150, 113, 173, 183, 255, 86, 206, 220, 163, 124, 136, 223, 196, 14, 204, 255, 159, 10, 101, 187, 188, 156, 50, 193, 224, 125, 193, 215, 253, 158, 131, 65, 196, 153, 187, 8, 8, 61, 34, 101, 112, 77, 161, 157, 48, 121, 10, 1, 183, 141, 109, 229, 48, 34, 131, 200, 88, 14, 126, 187, 101, 41, 228, 142, 208, 16, 101, 138, 150, 64, 95, 135, 191, 159, 184, 52, 240, 135, 255, 42, 17, 0, 61, 99, 51, 183, 75, 147, 255, 40, 26, 193, 200, 18, 14, 39, 163, 107, 62, 40, 225, 37, 180, 187, 234, 120, 140, 240, 246, 241, 84, 87, 180, 16, 191, 118, 192, 91, 51, 184, 170, 207, 79, 89, 169, 107, 110, 52, 193, 132, 69, 156, 76, 143, 195, 130, 178, 249, 242, 103, 248, 198, 98, 14, 24, 87, 50, 101, 234, 53, 49, 180, 200, 87, 211, 3, 29, 0, 235, 36, 208, 113, 22, 206, 22, 180, 41, 32, 0, 96, 67, 125, 92, 95] as [UInt8]
        let container = Data(containerBytes)
        let messages = try SecureDataMessage.decryptMessages(from: container, using: key)
        let expectedMessages = [
            Data(0 ... UInt8.max)
        ]
        
        XCTAssertEqual(messages, expectedMessages)
    }
    
    func testDecryptMessagesInvalidContainer() {
        let container = Data()
        let key = MasterKey()
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: container, using: key))
    }
    
    func testDecryptMessagesInvalidMasterKey() {
        let container = Data(repeating: 0, count: 64)
        let keyData = Data(repeating: 0, count: 32)
        let key = MasterKey(keyData)
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: container, using: key))
    }
  
    func testDecryptMessagesInvalidItemKey() {
        let keyData = Data(repeating: 0, count: 32)
        let key = MasterKey(keyData)
        let manipulatedContainerBytes = [1, 0, 0, 0, 0, 0, 0, 0, 230, 71, 51, 42, 174, 14, 187, 89, 134, 204, 216, 144, 230, 9, 4, 18, 5, 105, 254, 175, 207, 60, 206, 243, 167, 195, 125, 222, 155, 53, 33, 248, 31, 102, 90, 215, 125, 154, 88, 130, 21, 158, 216, 206, 246, 126, 80, 252, 236, 30, 209, 71, 3, 42, 147, 126, 60, 234, 195, 142, 35, 5, 172, 192, 41, 38, 213, 106, 110, 5, 208, 12, 94, 29, 9, 109, 178, 160, 127, 28, 41, 163, 155, 162, 29, 248, 174, 221] as [UInt8]
        let manipulatedContainer = Data(manipulatedContainerBytes)
        
        XCTAssertThrowsError(try SecureDataMessage.decryptMessages(from: manipulatedContainer, using: key))
    }
    
}

private struct CryptorStub: SecureDataMessageCryptor {
    
    let encryptionResult: AES.GCM.SealedBox?
    let authenticationEncryptionResult: AES.GCM.SealedBox?
    
    func encrypt<Plaintext>(_ message: Plaintext, using key: SymmetricKey) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol {
        guard let result = encryptionResult else {
            throw NSError()
        }
        
        return result
    }
    
    func encrypt<Plaintext, AuthenticatedData>(_ message: Plaintext, using key: SymmetricKey, authenticating authenticatedData: AuthenticatedData) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol, AuthenticatedData : DataProtocol {
        guard let result = authenticationEncryptionResult else {
            throw NSError()
        }
        
        return result
    }
    
}
