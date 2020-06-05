public struct Wifi: JSONCodable {
    
    public let networkName: String
    public let networkPassword: String
    
    public init(networkName: String, networkPassword: String) {
        self.networkName = networkName
        self.networkPassword = networkPassword
    }
    
}
