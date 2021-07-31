import Foundation

public struct CustomItem: Equatable, Codable {
    
    public let description: String?
    public let value: String?
    
    public init(description: String? = nil, value: String? = nil) {
        self.description = description
        self.value = value
    }
    
}

extension CustomItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .custom }
    
}
