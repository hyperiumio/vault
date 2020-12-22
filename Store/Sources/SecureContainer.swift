import Foundation

public struct SecureContainer {
    
    public let id: UUID
    public let name: String
    public let primaryItem: SecureItem
    public let secondaryItems: [SecureItem]
    public let created: Date
    public let modified: Date
    
    public var description: String? {
        switch primaryItem {
        case .password:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: modified)
        case .login(let item):
            return item.username
        case .file(let item):
            return ByteCountFormatter.string(fromByteCount: Int64(item.data.count), countStyle: .binary)
        case .note(let item):
            let firstLine = item.text.map { text in
                text.components(separatedBy: .newlines)
            }?.first
            return firstLine?.isEmpty == true ? nil : firstLine
        case .bankCard(let item):
            return item.name
        case .wifi(let item):
            return item.name
        case .bankAccount(let item):
            return item.accountHolder
        case .custom(let item):
            return item.description
        }
    }
    
    public init(id: UUID, name: String, primaryItem: SecureItem, secondaryItems: [SecureItem], created: Date, modified: Date) {
        self.id = id
        self.name = name
        self.primaryItem = primaryItem
        self.secondaryItems = secondaryItems
        self.created = created
        self.modified = modified
    }
    
}
