import Foundation

public struct LoginItem: Equatable, Codable  {
    
    public let username: String?
    public let password: String?
    public let url: String?
    
    public init(username: String? = nil, password: String? = nil, url: String? = nil) {
        self.username = username
        self.password = password
        self.url = url
    }
    
}

extension LoginItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .login }
    
}
