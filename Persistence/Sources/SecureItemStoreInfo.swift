import Foundation

public struct SecureItemStoreInfo: Codable {
    
    public let id: UUID
    public let keyVersion: Int
    public let itemVersion: Int
    public let created: Date
    
    init() {
        self.id = UUID()
        self.keyVersion = 1
        self.itemVersion = 1
        self.created = Date()
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
