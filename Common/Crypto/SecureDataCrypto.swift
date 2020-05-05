import CryptoKit
import Foundation

enum SecureDataCryptoError: Error {
    
    case invalidTagSegment
    case invalidMessageCount
    case invalidMessageIndex
    case invalidNonce
    case encryptionFailure
    case decryptionFailure
    
}

struct SecureDataDecryptionToken {
    
    let decodingToken: SecureDataDecodingToken
    let aesKey: SymmetricKey
    let tags: [Data]
    
    init(masterKey: SymmetricKey, context: ByteBufferContext) throws {
        let decodingToken = try SecureDataDecodingToken(from: context)
        
        let wrappedAesKey = try SecureDataDecodeAesKey(token: decodingToken, context: context)
        let wrappedHmacKey = try SecureDataDecodeHmacKey(token: decodingToken, context: context)
        let tagSegmentTag = try SecureDataDecodeTagSegmentTag(token: decodingToken, context: context)
        let tags = try SecureDataDecodeTags(token: decodingToken, context: context)
        let tagSegment = tags.reduce(.empty, +)
        
        let aesKey = try  KeyDecrypt(keyEncryptionKey: masterKey, wrappedKey: wrappedAesKey)
        let hmacKey = try KeyDecrypt(keyEncryptionKey: masterKey, wrappedKey: wrappedHmacKey)
        
        guard HMAC<SHA512>.isValidAuthenticationCode(tagSegmentTag, authenticating: tagSegment, using: hmacKey) else {
            throw SecureDataCryptoError.invalidTagSegment
        }
        
        self.decodingToken = decodingToken
        self.aesKey = aesKey
        self.tags = tags
    }
    
}

func SecureDataEncrypt(messages: [Data], using masterKey: SymmetricKey) throws -> Data {
    let aesKey = SymmetricKey(size: .bits256)
    let hmacKey = SymmetricKey(size: .bits256)

    let secureContainers = try messages.enumerated().map { index, message in
        do {
            let nonce = try AES.GCM.Nonce(counter: index)
            let seal = try AES.GCM.seal(message, using: aesKey, nonce: nonce)
            return SecureDataItem(ciphertext: seal.ciphertext, tag: seal.tag)
        } catch {
            throw SecureDataCryptoError.encryptionFailure
        }
    } as [SecureDataItem]
    
    let tagSegment = secureContainers.map(\.tag).reduce(.empty, +)
    let tagSegmentTag = HMAC<SHA512>.authenticationCode(for: tagSegment, using: hmacKey).bytes
    let wrappedHmacKey = try KeyEncrypt(keyEncryptionKey: masterKey, key: hmacKey)
    let wrappedAesKey = try KeyEncrypt(keyEncryptionKey: masterKey, key: aesKey)
    
    return try SecureDataEncode(aesKey: wrappedAesKey, hmacKey: wrappedHmacKey, tagSegmentTag: tagSegmentTag, secureContainers: secureContainers)
}

func SecureDataDecryptPlaintext(token: SecureDataDecryptionToken, context: ByteBufferContext, index: Int) throws -> Data {
    guard token.tags.indices.contains(index) else {
        throw SecureDataCryptoError.invalidMessageIndex
    }

    do {
        let nonce = try AES.GCM.Nonce(counter: index)
        let ciphertext = try SecureDataDecodeCiphertext(token: token.decodingToken, context: context, index: index)
        let tag = token.tags[index]
        let secureContainer = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try AES.GCM.open(secureContainer, using: token.aesKey)
    } catch {
        throw SecureDataCryptoError.decryptionFailure
    }
}

private extension AES.GCM.Nonce {
    
    init(counter: Int) throws {
        do {
            let encodedCounter = try UnsignedInteger32BitEncode(counter) + Data(count: 8)
            self = try AES.GCM.Nonce(data: encodedCounter)
        } catch {
            throw SecureDataCryptoError.invalidNonce
        }
    }
    
}
