import Foundation

struct VaultItemCryptor<Cryptor> where Cryptor: MultiMessageCryptor {
    
    private let version: VaultItem.Version
    private let dataCryptor: Cryptor
    
    init(using key: Cryptor.Key, from reader: FileReader) throws {
        let versionValue = try reader.byte(at: .versionIndex)
        let version = try VaultItem.Version(versionValue)
        let reader = reader.offset(by: VersionRepresentableEncodingSize)
        let dataCryptor = try Cryptor(using: key, from: reader)

        self.version = version
        self.dataCryptor = dataCryptor
    }

    func decryptedItemInfo(using key: Cryptor.Key, from reader: FileReader) throws -> VaultItem.Info {
        let reader = reader.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            return try dataCryptor.decryptedItemInfoVersion1(using: key, from: reader)
        }
    }
    
    func decryptedVaultItem(for itemInfo: VaultItem.Info, using key: Cryptor.Key, from reader: FileReader) throws -> VaultItem {
        let reader = reader.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            return try dataCryptor.decryptedVaultItemVersion1(for: itemInfo, using: key, from: reader)
        }
    }
    
}

extension VaultItemCryptor {
    
    static func encrypted(_ vaultItem: VaultItem, using masterKey: Cryptor.Key) throws -> Data {
        let version = VaultItem.Version.version1.encoded
        
        let encodedVaultItemInfo = try VaultItem.Info.jsonEncoded(vaultItem.info)
        
        let encodedSecureItems = try vaultItem.secureItems.map { secureItem in
            return try SecureItem.encoded(secureItem)
        }
        let messages = [encodedVaultItemInfo] + encodedSecureItems
        let secureData = try Cryptor.encrypted(messages, using: masterKey)
        
        return version + secureData
    }
    
    static func decryptedVaultItem(from url: URL, using masterKey: Cryptor.Key) throws -> VaultItem {
        return try FileReader.read(url: url) { fileReader in
            let cryptor = try VaultItemCryptor(using: masterKey, from: fileReader)
            let itemInfo = try cryptor.decryptedItemInfo(using: masterKey, from: fileReader)
            return try cryptor.decryptedVaultItem(for: itemInfo, using: masterKey, from: fileReader)
        }
    }
    
}

private extension MultiMessageCryptor {
    
    func decryptedItemInfoVersion1(using key: Key, from reader: FileReader) throws -> VaultItem.Info {
        return try decryptPlaintext(at: .infoIndex, using: key, from: reader).map { data in
            return try VaultItem.Info.jsonDecoded(data)
        }
    }
    
    func decryptedVaultItemVersion1(for itemInfo: VaultItem.Info, using key: Key, from reader: FileReader) throws -> VaultItem {
        let primarySecureItem = try decryptPlaintext(at: .primarySecureItemIndex, using: key, from: reader).map { data in
            return try SecureItem.decoded(data, asTypeMatching: itemInfo.primaryTypeIdentifier)
        }
        
        let secondarySecureItemIndexes = itemInfo.secondaryTypeIdentifiers.indices.moved(by: .secondarySecureItemsOffset)
        let secondarySecureItems = try zip(secondarySecureItemIndexes, itemInfo.secondaryTypeIdentifiers).map { index, type in
            return try decryptPlaintext(at: index, using: key, from: reader).map { data in
                return try SecureItem.decoded(data, asTypeMatching: type)
            }
        }
        
        return VaultItem(id: itemInfo.id, title: itemInfo.title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems)
    }
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemsOffset = 2
    
}
