import Foundation

public struct NoteItem: SecureItemValue, Codable, Equatable  {
    
    public let text: String
    
    public var type: SecureItemType { .note }
    
    public init(text: String) {
        self.text = text
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
