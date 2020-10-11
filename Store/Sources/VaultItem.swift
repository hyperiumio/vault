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
        
        let secondaryTypes = secondarySecureItems.map(\.value.type)
        return Info(id: id, name: name, description: description, primaryType: primarySecureItem.value.type, secondaryTypes: secondaryTypes, created: created, modified: modified)
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
        public let primaryType: SecureItemType
        public let secondaryTypes: [SecureItemType]
        public let created: Date
        public let modified: Date
        
        public func encoded() throws -> Data {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(self)
        }
        
        public init(id: UUID, name: String, description: String, primaryType: SecureItemType, secondaryTypes: [SecureItemType], created: Date, modified: Date) {
            self.id = id
            self.name = name
            self.description = description
            self.primaryType = primaryType
            self.secondaryTypes = secondaryTypes
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
