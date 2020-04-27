import Foundation

struct VaultItem {
    
    let id: UUID
    let title: String
    let secureItem: SecureItem
    let secondarySecureItems: [SecureItem]
    
    var info: Info {
        let secondaryItemTypes = secondarySecureItems.map(\.itemType)
        return Info(id: id, title: title,itemType: secureItem.itemType, secondaryItemTypes: secondaryItemTypes)
    }
    
    var secureItems: [SecureItem] {
        return [secureItem] + secondarySecureItems
    }
    
    init(id: UUID = UUID(), title: String, secureItem: SecureItem, secondarySecureItems: [SecureItem]) {
        self.id = id
        self.title = title
        self.secureItem = secureItem
        self.secondarySecureItems = secondarySecureItems
    }
    
}

extension VaultItem {
    
    struct Info: Codable, Identifiable {
        
        let id: UUID
        let title: String
        let itemType: SecureItemType
        let secondaryItemTypes: [SecureItemType]
        
        var itemTypes: [SecureItemType] {
            return [itemType] + secondaryItemTypes
        }
        
    }
    
}
