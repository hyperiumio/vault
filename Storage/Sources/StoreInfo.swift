import Foundation

public struct StoreInfo: Codable {
    
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
    
    public init(from data: Data) throws {
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
