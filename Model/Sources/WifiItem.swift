import Foundation

public struct WifiItem: Equatable, Codable {
    
    public let name: String?
    public let password: String?
    
    public init(name: String? = nil, password: String? = nil) {
        self.name = name
        self.password = password
    }
    
}

extension WifiItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .wifi }
    
}
