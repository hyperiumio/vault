import Foundation

protocol JSONCodable: Codable, Equatable {
    
    static func jsonEncoded(_ value: Self) throws -> Data
    static func jsonDecoded(_ data: Data) throws -> Self
    
}

extension JSONCodable {
    
    static func jsonEncoded(_ value: Self) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(value)
    }
    
    static func jsonDecoded(_ data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: data)
    }
    
}
