import Foundation

public struct PasswordItem: Equatable, Codable {
    
    public let password: String?
    
    public init(password: String? = nil) {
        self.password = password
    }
    
}

extension PasswordItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .password }
    
}
