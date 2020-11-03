import Foundation

public struct WifiItem: SecureItemValue, Codable, Equatable  {
    
    public let name: String?
    public let password: String?
    
    public var type: SecureItemType { .wifi }
    
    public init(name: String? = nil, password: String? = nil) {
        self.name = name
        self.password = password
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
