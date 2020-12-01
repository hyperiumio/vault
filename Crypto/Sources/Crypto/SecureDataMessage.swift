import CryptoKit
import Foundation

var SecureDataSeal = AES.GCM.seal as (Data, SymmetricKey, AES.GCM.Nonce?) throws -> AES.GCM.SealedBox

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
        let itemKey = CryptoKey()
        
        let seals = try messages.map { message in
            return try SecureDataSeal(message, itemKey.value, nil)
        }
        
        let tagSegment = seals.map(\.tag).reduce(.empty, +)
        
        let wrappedItemKey = try itemKey.value.withUnsafeBytes { itemKey in
            guard let wrappedItemKey = try AES.GCM.seal(itemKey, using: masterKey.value, authenticating: tagSegment).combined else {
                throw CryptoError.encryptionFailed
            }
            
            return wrappedItemKey
        } as Data
        
        let messageCount = UnsignedInteger32BitEncode(seals.count)
        
        let ciphertextSizes = seals.reduce(.empty) { result, seal in
            let ciphertextSize = UnsignedInteger32BitEncode(seal.ciphertext.count)
            return result + ciphertextSize
        } as Data
        
        let tags = seals.map(\.tag).reduce(.empty, +)
        
        let ciphertextContainers = seals.map { seal in
            return seal.nonce + seal.ciphertext
        }.reduce(.empty, +)
        
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
