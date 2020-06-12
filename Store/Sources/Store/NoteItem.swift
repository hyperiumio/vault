public struct NoteItem: JSONCodable {
    
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
}
