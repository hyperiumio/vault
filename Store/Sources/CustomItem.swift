import Foundation

public struct CustomItem: SecureItemValue, Codable, Equatable  {
    
    public let name: String
    public let value: String
    
    public var type: SecureItemType { .custom }
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
