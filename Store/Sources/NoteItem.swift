import Foundation

public struct NoteItem: SecureItemValue, Codable {
    
    public let text: String
    
    var type: SecureItemType { .note }
    
    public init(text: String) {
        self.text = text
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
