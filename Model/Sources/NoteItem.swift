import Foundation

public struct NoteItem: SecureItemValue, Codable, Equatable  {
    
    public let text: String?
    
    public static var secureItemType: SecureItemType { .note }
    
    public init(text: String? = nil) {
        self.text = text
    }
    
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public var encoded: Data {
        get throws {
            try JSONEncoder().encode(self)
        }
    }
    
}
