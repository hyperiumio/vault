import Foundation

public struct CustomItem: SecureItemValue, Codable, Equatable  {
    
    public let description: String?
    public let value: String?
    
    public var type: SecureItemType { .custom }
    
    public init(description: String? = nil, value: String? = nil) {
        self.description = description
        self.value = value
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
