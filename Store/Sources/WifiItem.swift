import Foundation

public struct WifiItem: SecureItemValue, Codable, Equatable  {
    
    public let networkName: String?
    public let networkPassword: String?
    
    public var type: SecureItemType { .wifi }
    
    public init(networkName: String? = nil, networkPassword: String? = nil) {
        self.networkName = networkName
        self.networkPassword = networkPassword
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
