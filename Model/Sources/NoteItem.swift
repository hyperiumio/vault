import Foundation

public struct NoteItem: Equatable, Codable {
    
    public let text: String?
    
    public init(text: String? = nil) {
        self.text = text
    }
    
}

extension NoteItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .note }
    
}
