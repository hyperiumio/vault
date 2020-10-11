import Foundation

public struct LoginItem: SecureItemValue, Codable {
    
    public let username: String
    public let password: String
    public let url: String
    
    var type: SecureItemType { .login }
    
    public init(username: String, password: String, url: String) {
        self.username = username
        self.password = password
        self.url = url
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
