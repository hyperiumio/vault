import CryptoKit
import Foundation

struct SecureData {
     
    private let aesKey: SymmetricKey
    private let tags: [Data]
    private let byteBuffer: SecureDataByteBuffer
    
    init(using masterKey: SymmetricKey, from context: ByteBufferContext) throws {
        let byteBuffer = try SecureDataByteBuffer(from: context)
        let keyCryptor = KeyCryptor(keyEncryptionKey: masterKey)
        
        let wrappedAesKey = try byteBuffer.readAesKey(from: context)
        let wrappedHmacKey = try byteBuffer.readHmacKey(from: context)
        let tagSegmentTag = try byteBuffer.readTagSegmentTag(from: context)
        let tags = try byteBuffer.readTags(from: context)
        let tagSegment = tags.reduce(.empty, +)
        
        let aesKey = try keyCryptor.unwrap(wrappedAesKey)
        let hmacKey = try keyCryptor.unwrap(wrappedHmacKey)
        
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
        let keyCryptor = KeyCryptor(keyEncryptionKey: masterKey)
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
        let wrappedHmacKey = try keyCryptor.wrap(hmacKey)
        let wrappedAesKey = try keyCryptor.wrap(aesKey)
        
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
        guard let counter = UInt32(exactly: counter)?.littleEndian.bytes else {
            throw SecureData.Error.invalidNonce
        }
        
        do {
            let paddedCounter = counter + Data(count: 8)
            self = try AES.GCM.Nonce(data: paddedCounter)
        } catch {
            throw SecureData.Error.invalidNonce
        }
    }
    
}