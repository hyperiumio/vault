public struct LoginItem: JSONCodable {
    
    public let username: String
    public let password: String
    public let url: String
    
    public init(username: String, password: String, url: String) {
        self.username = username
        self.password = password
        self.url = url
    }
    
}
