import Foundation

struct VaultItem {
    
    let id = UUID()
    let title: String
    let secureItems: [SecureItem]
    
    var info: Info {
        let itemTypes = secureItems.map(\.itemType)
        return Info(id: id, title: title, itemTypes: itemTypes)
    }
    
}

extension VaultItem {
    
    struct Info: Codable, Identifiable {
        
        let id: UUID
        let title: String
        let itemTypes: [SecureItemType]
        
    }
    
}
