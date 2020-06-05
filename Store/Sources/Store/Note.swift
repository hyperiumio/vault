public struct Note: JSONCodable {
    
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
}
