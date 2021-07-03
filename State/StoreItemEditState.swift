import Foundation
import Model

protocol StoreItemEditDependency {
    
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
}

@MainActor
class StoreItemEditState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems: [SecureItemState]
    
    let dependency: StoreItemEditDependency
    let editedStoreItem: StoreItem
    
    init(dependency: StoreItemEditDependency, editing storeItem: StoreItem) {
        self.dependency = dependency
        self.editedStoreItem = storeItem
        self.title = storeItem.name
        self.primaryItem = SecureItemState(from: storeItem.primaryItem)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            SecureItemState(from: item)
        }
    }
    
    var created: Date {
        editedStoreItem.created
    }
    
    var modified: Date {
        editedStoreItem.modified
    }
    
    func addSecondaryItem(with type: SecureItemType) {
        let secureItem = SecureItemState(from: type)
        secondaryItems.append(secureItem)
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
