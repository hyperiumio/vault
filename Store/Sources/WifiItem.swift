import Foundation

public struct WifiItem: SecureItemValue, Codable {
    
    public let networkName: String
    public let networkPassword: String
    
    var type: SecureItemType { .wifi }
    
    public init(networkName: String, networkPassword: String) {
        self.networkName = networkName
        self.networkPassword = networkPassword
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
