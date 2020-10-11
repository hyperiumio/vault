import Foundation

public struct PasswordItem: SecureItemValue, Codable {
    
    public let password: String
    
    var type: SecureItemType { .password }
    
    public init(password: String) {
        self.password = password
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
