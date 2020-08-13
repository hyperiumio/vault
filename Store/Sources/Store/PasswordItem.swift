public struct PasswordItem: BinaryCodable {
    
    public let password: String
    
    public init(password: String) {
        self.password = password
    }
    
}
