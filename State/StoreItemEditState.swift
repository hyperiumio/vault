import Event
import Foundation
import Model

@MainActor
class StoreItemEditState: ObservableObject {
    
    @Published var title: String
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems: [SecureItemState]
    @Published var editError: Error?
    let editedStoreItem: StoreItem
    private let inputBuffer = EventBuffer<Input>()
    
    init(editing storeItem: StoreItem, service: AppServiceProtocol) {
        self.editedStoreItem = storeItem
        self.title = storeItem.name
        self.primaryItem = SecureItemState(secureItem: storeItem.primaryItem, service: service)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            SecureItemState(secureItem: storeItem.primaryItem, service: service)
        }
        
        Task {
            for await input in inputBuffer.events {
                switch input {
                case let .saveStoreItem(storeItem):
                    do {
                        try await service.save(storeItem)
                    } catch {
                        editError = .saveDidFail
                    }
                case let .deleteStoreItem(itemID):
                    do {
                        try await service.delete(itemID: itemID)
                    } catch {
                        editError = .deleteDidFail
                    }
                case let .addItem(itemType):
                    let state = SecureItemState(itemType: itemType, service: service)
                    secondaryItems.append(state)
                case let .deleteItem(index):
                    secondaryItems.remove(at: index)
                }
            }
        }
    }
    
    var created: Date {
        editedStoreItem.created
    }
    
    var modified: Date {
        editedStoreItem.modified
    }
    
    func save() {
        let id = editedStoreItem.id
        let name = title
        let primaryItem = primaryItem.secureItem
        let secondaryItems = secondaryItems.map(\.secureItem)
        let created = editedStoreItem.created
        let modified = Date.now
        let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
        let input = Input.saveStoreItem(storeItem: storeItem)
        
        inputBuffer.enqueue(input)
    }
    
    func delete() {
        let input = Input.deleteStoreItem(itemID: editedStoreItem.id)
        inputBuffer.enqueue(input)
    }
    
    func addSecondaryItem(with itemType: SecureItemType) {
        let input = Input.addItem(itemType: itemType)
        inputBuffer.enqueue(input)
    }
    
    func deleteSecondaryItem(at index: Int) {
        let input = Input.deleteItem(index: index)
        inputBuffer.enqueue(input)
    }
    
}

extension StoreItemEditState {
    
    enum Input {
        
        case saveStoreItem(storeItem: StoreItem)
        case deleteStoreItem(itemID: UUID)
        case addItem(itemType: SecureItemType)
        case deleteItem(index: Int)
        
    }
    
    enum Error: Swift.Error {
        
        case saveDidFail
        case deleteDidFail
        
    }
    
}
