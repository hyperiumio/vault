public struct Password: JSONCodable {
    
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
}
