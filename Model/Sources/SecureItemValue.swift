import Foundation

public protocol SecureItemValue {
    
    var secureItemType: SecureItemType { get }
    var encoded: Data { get throws }
    
    init(from itemData: Data) throws
    
}

extension SecureItemValue {
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
}

extension SecureItemValue where Self: Codable {
    
    public init(from itemData: Data) throws {
        self = try Self.decoder.decode(Self.self, from: itemData)
    }
    
    public var encoded: Data {
        get throws {
            try Self.encoder.encode(self)
        }
    }
    
}
