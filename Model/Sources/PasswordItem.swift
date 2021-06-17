import Foundation

public struct PasswordItem: SecureItemValue, Codable, Equatable {
    
    public let password: String?
    
    public static var secureItemType: SecureItemType { .password }
    
    public init(password: String? = nil) {
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
