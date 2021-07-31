import Foundation

public struct StoreItem: Equatable {
    
    public let id: UUID
    public let name: String
    public let primaryItem: SecureItem
    public let secondaryItems: [SecureItem]
    public let created: Date
    public let modified: Date
    
    public init(id: UUID, name: String, primaryItem: SecureItem, secondaryItems: [SecureItem], created: Date, modified: Date) {
        self.id = id
        self.name = name
        self.primaryItem = primaryItem
        self.secondaryItems = secondaryItems
        self.created = created
        self.modified = modified
    }
    
    public var description: String? {
        switch primaryItem {
        case .password:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: modified)
        case .login(let item):
            return item.username
        case .file(let item):
            guard let count = item.value?.data.count, let byteCount = Int64(exactly: count) else {
                return nil
            }
            return ByteCountFormatter.string(fromByteCount: byteCount, countStyle: .binary)
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
    
    public var info: StoreItemInfo {
        let secondaryTypes = secondaryItems.map(\.value.secureItemType)
        return StoreItemInfo(id: id, name: name, description: description, primaryType: primaryItem.value.secureItemType, secondaryTypes: secondaryTypes, created: created, modified: modified)
    }
    
}
