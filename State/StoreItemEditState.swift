import Foundation
import Model

@MainActor
class StoreItemEditState: ObservableObject {
    
    @Published var title: String
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems: [SecureItemState]
    @Published var editError: Error?
    
    let editedStoreItem: StoreItem
    
    private let dependency: Dependency
    
    init(editing storeItem: StoreItem, dependency: Dependency) {
        self.editedStoreItem = storeItem
        self.title = storeItem.name
        self.primaryItem = SecureItemState(secureItem: storeItem.primaryItem, dependency: dependency)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            SecureItemState(secureItem: storeItem.primaryItem, dependency: dependency)
        }
        self.dependency = dependency
    }
    
    var created: Date {
        editedStoreItem.created
    }
    
    var modified: Date {
        editedStoreItem.modified
    }
    
    func addSecondaryItem(with itemType: SecureItemType) {
        let state = SecureItemState(itemType: itemType, dependency: dependency)
        secondaryItems.append(state)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItems.remove(at: index)
    }
    
    func save() async throws {
        editError = nil
        
        do {
            let id = editedStoreItem.id
            let name = title
            let primaryItem = primaryItem.secureItem
            let secondaryItems = secondaryItems.map(\.secureItem)
            let created = editedStoreItem.created
            let modified = Date.now
            let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
            try await dependency.storeItemService.save(storeItem)
        } catch {
            editError = .saveDidFail
        }
    }
    
    func delete() async {
        editError = nil
        
        do {
            try await dependency.storeItemService.delete(itemID: editedStoreItem.id)
        } catch {
            editError = .deleteDidFail
        }
    }
    
}

extension StoreItemEditState {
    
    enum Error: Swift.Error {
        
        case saveDidFail
        case deleteDidFail
        
    }
    
}
