import Foundation

public struct PasswordItem: SecureItemValue, Codable, Equatable {
    
    public let password: String?
    
    public var type: SecureItemType { .password }
    
    public init(password: String? = nil) {
        self.password = password
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
