import CryptoKit
import Foundation

struct SecureData {
     
    private let aesKey: SymmetricKey
    private let tags: [Data]
    private let byteBuffer: SecureDataByteBuffer
    
    init(using masterKey: SymmetricKey, from context: ByteBufferContext) throws {
        let byteBuffer = try SecureDataByteBuffer(from: context)
        
        let wrappedAesKey = try byteBuffer.readAesKey(from: context)
        let wrappedHmacKey = try byteBuffer.readHmacKey(from: context)
        let tagSegmentTag = try byteBuffer.readTagSegmentTag(from: context)
        let tags = try byteBuffer.readTags(from: context)
        let tagSegment = tags.reduce(.empty, +)
        
        let aesKey = try  KeyDecrypt(keyEncryptionKey: masterKey, wrappedKey: wrappedAesKey)
        let hmacKey = try KeyDecrypt(keyEncryptionKey: masterKey, wrappedKey: wrappedHmacKey)
        
        guard HMAC<SHA512>.isValidAuthenticationCode(tagSegmentTag, authenticating: tagSegment, using: hmacKey) else {
            throw Error.invalidTagSegment
        }
        
        self.aesKey = aesKey
        self.tags = tags
        self.byteBuffer = byteBuffer
    }
    
    func plaintext(at index: Int, from context: ByteBufferContext) throws -> Data {
        guard tags.indices.contains(index) else {
            throw Error.invalidMessageIndex
        }

        do {
            let nonce = try AES.GCM.Nonce(counter: index)
            let ciphertext = try byteBuffer.readCiphertext(at: index, from: context)
            let tag = tags[index]
            let secureContainer = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
            return try AES.GCM.open(secureContainer, using: aesKey)
        } catch {
            throw Error.decryptionFailure
        }
    }
    
}

extension SecureData {
    
    static func encode(messages: [Data], using masterKey: SymmetricKey) throws -> Data {
        let aesKey = SymmetricKey(size: .bits256)
        let hmacKey = SymmetricKey(size: .bits256)

        let secureContainers = try messages.enumerated().map { index, message in
            do {
                let nonce = try AES.GCM.Nonce(counter: index)
                let seal = try AES.GCM.seal(message, using: aesKey, nonce: nonce)
                return SecureDataByteBuffer.SecureContainer(ciphertext: seal.ciphertext, tag: seal.tag)
            } catch {
                throw Error.encryptionFailure
            }
        } as [SecureDataByteBuffer.SecureContainer]
        
        let tagSegment = secureContainers.map(\.tag).reduce(.empty, +)
        let tagSegmentTag = HMAC<SHA512>.authenticationCode(for: tagSegment, using: hmacKey).bytes
        let wrappedHmacKey = try KeyEncrypt(keyEncryptionKey: masterKey, key: hmacKey)
        let wrappedAesKey = try KeyEncrypt(keyEncryptionKey: masterKey, key: aesKey)
        
        return try SecureDataByteBuffer.encode(aesKey: wrappedAesKey, hmacKey: wrappedHmacKey, tagSegmentTag: tagSegmentTag, secureContainers: secureContainers)
    }
    
}

extension SecureData {
    
    enum Error: Swift.Error {
        
        case invalidTagSegment
        case invalidMessageCount
        case invalidMessageIndex
        case invalidNonce
        case encryptionFailure
        case decryptionFailure
        
    }
    
}

private extension AES.GCM.Nonce {
    
    init(counter: Int) throws {
        do {
            let encodedCounter = try UnsignedInteger32BitEncode(counter) + Data(count: 8)
            self = try AES.GCM.Nonce(data: encodedCounter)
        } catch {
            throw SecureData.Error.invalidNonce
        }
    }
    
}
