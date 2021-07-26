import Foundation
import Model

protocol StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    
    func secureItemDependency() -> SecureItemDependency
    
}

@MainActor
class StoreItemEditState: ObservableObject {
    
    @Published var title: String
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems: [SecureItemState]
    
    let dependency: StoreItemEditDependency
    let editedStoreItem: StoreItem
    
    init(dependency: StoreItemEditDependency, editing storeItem: StoreItem) {
        let secureItemDependency = dependency.secureItemDependency()
        
        self.dependency = dependency
        self.editedStoreItem = storeItem
        self.title = storeItem.name
        self.primaryItem = SecureItemState(dependency: secureItemDependency, secureItem: storeItem.primaryItem)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            SecureItemState(dependency: secureItemDependency, secureItem: storeItem.primaryItem)
        }
    }
    
    var created: Date {
        editedStoreItem.created
    }
    
    var modified: Date {
        editedStoreItem.modified
    }
    
    func addSecondaryItem(with itemType: SecureItemType) {
        let secureItemDependency = dependency.secureItemDependency()
        let state = SecureItemState(dependency: secureItemDependency, itemType: itemType)
        
        secondaryItems.append(state)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItems.remove(at: index)
    }
    
    func save() async throws {
        do {
            let id = editedStoreItem.id
            let name = title
            let primaryItem = primaryItem.secureItem
            let secondaryItems = secondaryItems.map(\.secureItem)
            let created = editedStoreItem.created
            let modified = Date.now
            let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
            try await dependency.save(storeItem)
        } catch {
            
        }
    }
    
    func delete() async {
        do {
            try await dependency.delete(itemID: editedStoreItem.id)
        } catch {
            
        }
    }
    
}
