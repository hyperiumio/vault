import Foundation

public struct VaultItem {
    
    public let id: UUID
    public let title: String
    public let primarySecureItem: SecureItem
    public let secondarySecureItems: [SecureItem]
    public let created: Date
    public let modified: Date
    
    var info: Info {
        let secondaryTypeIdentifiers = secondarySecureItems.map(\.typeIdentifier)
        return Info(id: id, title: title, primaryTypeIdentifier: primarySecureItem.typeIdentifier, secondaryTypeIdentifiers: secondaryTypeIdentifiers, created: created, modified: modified)
    }
    
    public init(id: UUID, title: String, primarySecureItem: SecureItem, secondarySecureItems: [SecureItem], created: Date, modified: Date) {
        self.id = id
        self.title = title
        self.primarySecureItem = primarySecureItem
        self.secondarySecureItems = secondarySecureItems
        self.created = created
        self.modified = modified
    }
    
}

extension VaultItem {
    
    public struct Info: BinaryCodable, Hashable {
        
        public let id: UUID
        public let title: String
        public let primaryTypeIdentifier: SecureItem.TypeIdentifier
        public let secondaryTypeIdentifiers: [SecureItem.TypeIdentifier]
        public let created: Date
        public let modified: Date
        
    }
    
    enum Version: UInt8, VersionRepresentable {
        
        case version1 = 1
        
    }

}

extension VaultItem {
    
    static func decrypted(from fileReader: FileReader, using cryptor: CryptoOperationProvider) throws -> VaultItem {
        let versionValue = try fileReader.byte(at: .versionIndex)
        let version = try VaultItem.Version(versionValue)
        let fileReader = fileReader.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            let info = try cryptor.decrypted(messageAt: .infoIndex, from: fileReader).map { data in
                try Info(binaryEncoded: data)
            }
            
            let primarySecureItem = try cryptor.decrypted(messageAt: .primarySecureItemIndex, from: fileReader).map { data in
                try SecureItem.decoded(data, asTypeMatching: info.primaryTypeIdentifier)
            }
            
            let secondarySecureItemIndexes = info.secondaryTypeIdentifiers.indices.moved(by: .secondarySecureItemsOffset)
            let secondarySecureItems = try zip(secondarySecureItemIndexes, info.secondaryTypeIdentifiers).map { index, type in
                try cryptor.decrypted(messageAt: index, from: fileReader).map { data in
                    try SecureItem.decoded(data, asTypeMatching: type)
                }
            }
            
            return VaultItem(id: info.id, title: info.title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: info.created, modified: info.modified)
        }
    }
    
    static func encrypted(_ vaultItem: VaultItem, using cryptor: CryptoOperationProvider) throws -> Data {
        let encodedVaultItemInfo = try vaultItem.info.binaryEncoded()
        let encodedPrimarySecureItem = try SecureItem.encoded(vaultItem.primarySecureItem)
        let encodedSecondarySecureItems = try vaultItem.secondarySecureItems.map { secureItem in
            try SecureItem.encoded(secureItem)
        }
        
        let messages = [encodedVaultItemInfo, encodedPrimarySecureItem] + encodedSecondarySecureItems
        let secureData = try cryptor.encrypted(messages)

        return Version.version1.encoded + secureData
    }
    
}

extension VaultItem.Info {
    
    static func ciphertextContainer(from fileReader: FileReader, using cryptor: CryptoOperationProvider) throws -> CiphertextContainerRepresentable {
        let versionValue = try fileReader.byte(at: .versionIndex)
        let version = try VaultItem.Version(versionValue)
        let fileReader = fileReader.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            return try cryptor.ciphertextContainer(at: .infoIndex, from: fileReader)
        }
        
    }
    
    static func decrypted(from ciphertextContainers: [CiphertextContainerRepresentable], using cryptor: CryptoOperationProvider) throws -> [VaultItem.Info] {
        try ciphertextContainers.map { ciphertextContainer in
            try cryptor.decrypted(ciphertextContainer).map { data in
                try Self(binaryEncoded: data)
            }
        }
    }
    
    static func decrypted(from fileReader: FileReader, using cryptor: CryptoOperationProvider) throws -> VaultItem.Info {
        let versionValue = try fileReader.byte(at: .versionIndex)
        let version = try VaultItem.Version(versionValue)
        let fileReader = fileReader.offset(by: VersionRepresentableEncodingSize)
        
        switch version {
        case .version1:
            return try cryptor.decrypted(messageAt: .infoIndex, from: fileReader).map { data in
                try Self(binaryEncoded: data)
            }
        }
    }
    
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemsOffset = 2
    
}
