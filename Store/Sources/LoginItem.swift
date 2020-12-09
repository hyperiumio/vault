import Foundation

public struct LoginItem: SecureItemValue, Codable, Equatable  {
    
    public let username: String?
    public let password: String?
    public let url: String?
    
    public static var secureItemType: SecureItemType { .login }
    
    public init(username: String? = nil, password: String? = nil, url: String? = nil) {
        self.username = username
        self.password = password
        self.url = url
    }
    
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
