public struct PasswordItem: JSONCodable {
    
    public let password: String
    
    public init(password: String) {
        self.password = password
    }
    
}
