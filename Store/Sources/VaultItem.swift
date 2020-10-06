import Foundation

public struct VaultItem {
    
    public let id: UUID
    public let name: String
    public let primarySecureItem: SecureItem
    public let secondarySecureItems: [SecureItem]
    public let created: Date
    public let modified: Date
    
    public var info: Info {
        let description: String
        switch primarySecureItem {
        case .password:
            description = DateFormatter().string(from: modified)
        case .login(let item):
            description = item.username
        case .file(let item):
            let byteCount = item.data?.count ?? 0
            description = ByteCountFormatter.string(fromByteCount: Int64(byteCount), countStyle: .binary)
        case .note(let item):
            description = item.text.components(separatedBy: .newlines).first ?? ""
        case .bankCard(let item):
            description = item.name
        case .wifi(let item):
            description = item.networkName
        case .bankAccount(let item):
            description = item.accountHolder
        case .custom(let item):
            description = item.name
        }
        
        let secondaryTypeIdentifiers = secondarySecureItems.map(\.typeIdentifier)
        return Info(id: id, name: name, description: description, primaryTypeIdentifier: primarySecureItem.typeIdentifier, secondaryTypeIdentifiers: secondaryTypeIdentifiers, created: created, modified: modified)
    }
    
    public init(id: UUID, name: String, primarySecureItem: SecureItem, secondarySecureItems: [SecureItem], created: Date, modified: Date) {
        self.id = id
        self.name = name
        self.primarySecureItem = primarySecureItem
        self.secondarySecureItems = secondarySecureItems
        self.created = created
        self.modified = modified
    }
    
}

extension VaultItem {
    
    public struct Info: Codable, Hashable {
        
        public let id: UUID
        public let name: String
        public let description: String
        public let primaryTypeIdentifier: SecureItem.TypeIdentifier
        public let secondaryTypeIdentifiers: [SecureItem.TypeIdentifier]
        public let created: Date
        public let modified: Date
        
        public func encoded() throws -> Data {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(self)
        }
        
        public init(id: UUID, name: String, description: String, primaryTypeIdentifier: SecureItem.TypeIdentifier, secondaryTypeIdentifiers: [SecureItem.TypeIdentifier], created: Date, modified: Date) {
            self.id = id
            self.name = name
            self.description = description
            self.primaryTypeIdentifier = primaryTypeIdentifier
            self.secondaryTypeIdentifiers = secondaryTypeIdentifiers
            self.created = created
            self.modified = modified
        }
        
        public init(from data: Data) throws {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            self = try decoder.decode(Self.self, from: data)
        }
        
    }

}
