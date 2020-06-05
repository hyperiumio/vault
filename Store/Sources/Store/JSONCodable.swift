import Foundation

protocol JSONCodable: Codable, Equatable {
    
    static func jsonEncoded(_ value: Self) throws -> Data
    static func jsonDecoded(_ data: Data) throws -> Self
    
}

extension JSONCodable {
    
    static func jsonEncoded(_ value: Self) throws -> Data {
        return try JSONEncoder().encode(value)
    }
    
    static func jsonDecoded(_ data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
}
