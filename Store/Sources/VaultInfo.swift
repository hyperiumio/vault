import Foundation

struct VaultInfo: Codable {
    
    public let id: UUID
    public let createdAt: Date
    public let keyVersion: Int
    public let itemVersion: Int
    
    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.keyVersion = 1
        self.itemVersion = 1
    }
    
    init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
}
