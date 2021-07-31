import Foundation

public struct StoreItemInfo: Hashable, Identifiable, Codable {
    
    public let id: UUID
    public let name: String
    public let description: String?
    public let primaryType: SecureItemType
    public let secondaryTypes: [SecureItemType]
    public let created: Date
    public let modified: Date
    
    public init(id: UUID, name: String, description: String?, primaryType: SecureItemType, secondaryTypes: [SecureItemType], created: Date, modified: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.primaryType = primaryType
        self.secondaryTypes = secondaryTypes
        self.created = created
        self.modified = modified
    }
    
    public init(from itemData: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: itemData)
    }
    
    public var encoded: Data {
        get throws {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(self)
        }
    }
    
}
