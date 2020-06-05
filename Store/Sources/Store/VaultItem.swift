import Foundation

public struct VaultItem {
    
    public let id: UUID
    public let title: String
    public let primarySecureItem: SecureItem
    public let secondarySecureItems: [SecureItem]
    
    var info: Info {
        let secondaryTypeIdentifiers = secondarySecureItems.map(\.typeIdentifier)
        return Info(id: id, title: title, primaryTypeIdentifier: primarySecureItem.typeIdentifier, secondaryTypeIdentifiers: secondaryTypeIdentifiers)
    }
    
    public var secureItems: [SecureItem] {
        return [primarySecureItem] + secondarySecureItems
    }
    
    public init(id: UUID = UUID(), title: String, primarySecureItem: SecureItem, secondarySecureItems: [SecureItem]) {
        self.id = id
        self.title = title
        self.primarySecureItem = primarySecureItem
        self.secondarySecureItems = secondarySecureItems
    }
    
}

extension VaultItem {
    
    struct Info: JSONCodable {
        
        public let id: UUID
        public let title: String
        public let primaryTypeIdentifier: SecureItem.TypeIdentifier
        public let secondaryTypeIdentifiers: [SecureItem.TypeIdentifier]
        
        public var typeIdentifiers: [SecureItem.TypeIdentifier] {
            return [primaryTypeIdentifier] + secondaryTypeIdentifiers
        }
        
    }
    
    enum Version: UInt8, VersionRepresentable {
        
        case version1 = 1
        
    }

}
