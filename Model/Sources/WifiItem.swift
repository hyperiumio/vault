import Foundation

public struct WifiItem: SecureItemValue, Codable, Equatable  {
    
    public let name: String?
    public let password: String?
    
    public static var secureItemType: SecureItemType { .wifi }
    
    public init(name: String? = nil, password: String? = nil) {
        self.name = name
        self.password = password
    }
    
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public var encoded: Data {
        get throws {
            try JSONEncoder().encode(self)
        }
    }
    
}
