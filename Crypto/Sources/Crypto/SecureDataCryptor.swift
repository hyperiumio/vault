import CryptoKit
import Foundation

var SecureDataSeal = AES.GCM.seal as (Data, SymmetricKey, AES.GCM.Nonce?) throws -> AES.GCM.SealedBox

public enum SecureDataError: Error {
    
    case invalidMessageIndex
    case encryptionFailure
    case decryptionFailure
    
}

public struct SecureDataCryptor {
    
    private let versionedCryptor: SecureDataCryptorRepresentable
    
    public init(using masterKey: MasterKey, from context: DataContext) throws {
        let versionValue = try context.byte(at: .versionIndex)
        let version = try Version(versionValue)
        let context = context.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            self.versionedCryptor = try SecureDataCryptorVersion1(masterKey: masterKey, context: context)
        }
    }
    
    public func decryptPlaintext(at index: Int, using masterKey: MasterKey, from context: DataContext) throws -> Data {
        let context = context.offset(by: VersionRepresentableEncodingSize)
        return try versionedCryptor.decryptPlaintext(at: index, using: masterKey, from: context)
    }
    
}

extension SecureDataCryptor {
    
    enum Version: UInt8, VersionRepresentable {
        
        case version1 = 1
        
    }
    
}

extension SecureDataCryptor {
    
    public static func encrypted(_ messages: [Data], using masterKey: MasterKey) throws -> Data {
        let version = Version.version1.encoded
        
        let itemKey = SymmetricKey(size: .bits256)

        let seals = try messages.map { message in
            return try SecureDataSeal(message, itemKey, nil)
        }
        
        let tagSegment = seals.map(\.tag).reduce(.empty, +)
        
        let wrappedItemKey = try itemKey.withUnsafeBytes { itemKey in
            guard let wrappedItemKey = try AES.GCM.seal(itemKey, using: masterKey.cryptoKey, authenticating: tagSegment).combined else {
                throw SecureDataError.encryptionFailure
            }
            
            return wrappedItemKey
        } as Data
        
        let secureData = try SecureDataCoder.encode(wrappedItemKey: wrappedItemKey, seals: seals)
        
        return version + secureData
    }
    
}

private protocol SecureDataCryptorRepresentable {
    
    func decryptPlaintext(at index: Int, using masterKey: MasterKey, from context: DataContext) throws -> Data
    
}

private struct SecureDataCryptorVersion1 {
    
    let coder: SecureDataCoder
    let itemKey: SymmetricKey
    let tags: [Data]
    
    public init(masterKey: MasterKey, context: DataContext) throws {
        let coder = try SecureDataCoder(from: context)
        
        let wrappedItemKey = try coder.decodeItemKey(from: context).map { data in
            return try AES.GCM.SealedBox(combined: data)
        }
        let tags = try coder.decodeTags(from: context)
        let tagSegment = tags.reduce(.empty, +)
        
        let itemKey = try AES.GCM.open(wrappedItemKey, using: masterKey.cryptoKey, authenticating: tagSegment).map { data in
            return SymmetricKey(data: data)
        }
        
        self.coder = coder
        self.itemKey = itemKey
        self.tags = tags
    }
    
}

extension SecureDataCryptorVersion1: SecureDataCryptorRepresentable {
    
    func decryptPlaintext(at index: Int, using masterKey: MasterKey, from context: DataContext) throws -> Data {
        guard tags.indices.contains(index) else {
            throw SecureDataError.invalidMessageIndex
        }

        do {
            let nonce = try coder.decodeNonce(at: index, from: context).map { data in
                return try AES.GCM.Nonce(data: data)
            }
            let ciphertext = try coder.decodeCiphertext(at: index, from: context)
            let tag = tags[index]
            let seal = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
            return try AES.GCM.open(seal, using: itemKey)
        } catch {
            throw SecureDataError.decryptionFailure
        }
    }
    
}

private extension Int {

    static let versionIndex = 0

}
