import Collection
import Foundation
import Model

@MainActor
class CreateItemState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems = [SecureItemState]()
    @Published var createError: Error?
    
    private let inputs = Queue<Input>()
    
    init(itemType: SecureItemType, service: AppServiceProtocol) {
        self.primaryItem = SecureItemState(itemType: itemType, service: service)
        
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case let .save(storeItem):
                    do {
                        try await service.save(storeItem)
                    } catch {
                        createError = .saveDidFail
                    }
                }
            }
        }
    }
    
    func save() {
        let id = UUID()
        let name = title
        let primaryItem = primaryItem.secureItem
        let secondaryItems = secondaryItems.map(\.secureItem)
        let created = Date.now
        let modified = created
        let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
        let input = Input.save(storeItem: storeItem)
        
        Task {
            await inputs.enqueue(input)
        }
    }
    
}

extension CreateItemState {
    
    enum Error: Swift.Error {
        
        case saveDidFail
        
    }
    
    enum Input {
        
        case save(storeItem: StoreItem)
        
    }
    
}
