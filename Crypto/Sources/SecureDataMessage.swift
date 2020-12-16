import CryptoKit
import Foundation

public struct SecureDataMessage {
    
    let nonce: Data
    let ciphertext: Data
    let tag: Data
    
    public init(nonce: Data, ciphertext: Data, tag: Data) {
        self.nonce = nonce
        self.ciphertext = ciphertext
        self.tag = tag
    }
    
    public func decrypt(using itemKey: CryptoKey) throws -> Data {
        let nonce = try AES.GCM.Nonce(data: self.nonce)
        let seal = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        
        return try AES.GCM.open(seal, using: itemKey.value)
    }
    
}

extension SecureDataMessage {
    
    public static func encryptContainer(from messages: [Data], using masterKey: CryptoKey) throws -> Data {
        let productionCryptor = Cryptor()
        return try encryptContainer(from: messages, using: masterKey, cryptor: productionCryptor)
    }
    
    static func encryptContainer(from messages: [Data], using masterKey: CryptoKey, cryptor: SecureDataMessageCryptor) throws -> Data {
        let itemKey = CryptoKey()
        
        let seals = try messages.map { message in
            try cryptor.encrypt(message, using: itemKey.value)
        }
        
        let tagSegment = seals.map(\.tag).reduce(Data(), +)
        
        let wrappedItemKey = try itemKey.value.withUnsafeBytes { itemKey in
            guard let wrappedItemKey = try cryptor.encrypt(itemKey, using: masterKey.value, authenticating: tagSegment).combined else {
                throw CryptoError.encryptionFailed
            }
            
            return wrappedItemKey
        } as Data
        
        let sealsCount = UInt32(seals.count)
        let messageCount = UnsignedInteger32BitEncode(sealsCount)
        
        let ciphertextSizes = seals.reduce(Data()) { result, seal in
            let ciphertextSize = UInt32(seal.ciphertext.count)
            return result + UnsignedInteger32BitEncode(ciphertextSize)
        } as Data
        
        let tags = seals.map(\.tag).reduce(Data(), +)
        
        let ciphertextContainers = seals.map { seal in
            seal.nonce + seal.ciphertext
        }.reduce(Data(), +)
        
        return messageCount + ciphertextSizes + wrappedItemKey + tags + ciphertextContainers
    }
    
    public static func decryptMessages(from container: Data, using masterKey: CryptoKey) throws -> [Data] {
        let header = try SecureDataHeader(data: container)
        let itemKey = try header.unwrapKey(with: masterKey)
        
        return try header.elements.map { element in
            let nonce = container[element.nonceRange]
            let ciphertext = container[element.ciphertextRange]
            return try SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: element.tag).decrypt(using: itemKey)
        }
    }
    
}

protocol SecureDataMessageCryptor {
    
    func encrypt<Plaintext>(_ message: Plaintext, using key: SymmetricKey) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol
    func encrypt<Plaintext, AuthenticatedData>(_ message: Plaintext, using key: SymmetricKey, authenticating authenticatedData: AuthenticatedData) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol, AuthenticatedData : DataProtocol
    
}

extension SecureDataMessage {
    
    struct Cryptor: SecureDataMessageCryptor {
        
        func encrypt<Plaintext>(_ message: Plaintext, using key: SymmetricKey) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol {
            try AES.GCM.seal(message, using: key)
        }
        
        func encrypt<Plaintext, AuthenticatedData>(_ message: Plaintext, using key: SymmetricKey, authenticating authenticatedData: AuthenticatedData) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol, AuthenticatedData : DataProtocol {
            try AES.GCM.seal(message, using: key, authenticating: authenticatedData)
        }
    }
    
}
