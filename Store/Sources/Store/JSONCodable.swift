import Foundation

public protocol JSONCodable: Codable, Equatable {
    
    init(jsonEncoded: Data) throws
    
    func jsonEncoded() throws -> Data
    
}

public extension JSONCodable {
    
    func jsonEncoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return try encoder.encode(self)
    }
    
    init(jsonEncoded data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        self = try decoder.decode(Self.self, from: data)
    }
    
}
