import CryptoKit
import Foundation

public enum SecureDataError: Error {
    
    case invalidMessageIndex
    case encryptionFailure
    case decryptionFailure
    
}

public struct SecureDataDecryptionToken {
    
    fileprivate let version: SecureDataDecryptionTokenVersion
    
    public init(masterKey: MasterKey, context: DataContext) throws {
        let versionValue = try context.byte(at: .versionIndex)
        let version = try SecureDataVersion(versionValue)
        let decryptionTokenContext = context.offset(by: VersionRepresentableByteCount)
        
        switch version {
        case .version1:
            let token = try SecureDataDecryptionTokenVersion1(masterKey: masterKey, context: decryptionTokenContext)
            self.version = .version1(token)
        }
    }
    
}

public func SecureDataEncrypt(_ messages: [Data], with masterKey: MasterKey) throws -> Data {
    let version = SecureDataVersion.version1.encoded
    
    let itemKey = SymmetricKey(size: .bits256)

    let seals = try messages.map { message in
        return try AES.GCM.seal(message, using: itemKey)
    }
    
    let tagSegment = seals.map(\.tag).reduce(.empty, +)
    
    let wrappedItemKey = try itemKey.withUnsafeBytes { itemKey in
        guard let wrappedItemKey = try AES.GCM.seal(itemKey, using: masterKey.cryptoKey, authenticating: tagSegment).combined else {
            throw SecureDataError.encryptionFailure
        }
        
        return wrappedItemKey
    } as Data
    
    let secureData = try SecureDataEncode(wrappedItemKey: wrappedItemKey, seals: seals)
    
    return version + secureData
}

public func SecureDataDecryptPlaintext(at index: Int, using token: SecureDataDecryptionToken, from context: DataContext) throws -> Data {
    let context = context.offset(by: VersionRepresentableByteCount)
    switch token.version {
    case .version1(let token):
        return try SecureDataDecryptPlaintextVersion1(at: index, using: token, from: context)
    }
}

private enum SecureDataDecryptionTokenVersion {
    
    case version1(SecureDataDecryptionTokenVersion1)
    
}

private struct SecureDataDecryptionTokenVersion1 {
    
    let decodingToken: SecureDataDecodingToken
    let itemKey: SymmetricKey
    let tags: [Data]
    
    public init(masterKey: MasterKey, context: DataContext) throws {
        let decodingToken = try SecureDataDecodingToken(from: context)
        
        let wrappedItemKey = try SecureDataDecodeItemKey(token: decodingToken, context: context).map { data in
            return try AES.GCM.SealedBox(combined: data)
        }
        let tags = try SecureDataDecodeTags(token: decodingToken, context: context)
        let tagSegment = tags.reduce(.empty, +)
        
        let itemKey = try AES.GCM.open(wrappedItemKey, using: masterKey.cryptoKey, authenticating: tagSegment).map { data in
            return SymmetricKey(data: data)
        }
        
        self.decodingToken = decodingToken
        self.itemKey = itemKey
        self.tags = tags
    }
    
}

private func SecureDataDecryptPlaintextVersion1(at index: Int, using token: SecureDataDecryptionTokenVersion1, from context: DataContext) throws -> Data {
    guard token.tags.indices.contains(index) else {
        throw SecureDataError.invalidMessageIndex
    }

    do {
        let nonce = try SecureDataDecodeNonce(index: index, token: token.decodingToken, context: context).map { data in
            return try AES.GCM.Nonce(data: data)
        }
        let ciphertext = try SecureDataDecodeCiphertext(index: index, token: token.decodingToken, context: context)
        let tag = token.tags[index]
        let seal = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try AES.GCM.open(seal, using: token.itemKey)
    } catch {
        throw SecureDataError.decryptionFailure
    }
}

private extension Int {

    static let versionIndex = 0

}
