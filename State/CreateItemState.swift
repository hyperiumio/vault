import Foundation
import Model

@MainActor
class CreateItemState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems = [SecureItemState]()
    @Published var createError: Error?
    
    private let service: AppServiceProtocol
    
    init(itemType: SecureItemType, service: AppServiceProtocol) {
        self.primaryItem = SecureItemState(itemType: itemType, service: service)
        self.service = service
    }
    
    func save() async {
        createError = nil
        
        do {
            let id = UUID()
            let name = title
            let primaryItem = primaryItem.secureItem
            let secondaryItems = secondaryItems.map(\.secureItem)
            let created = Date.now
            let modified = created
            let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
            try await service.save(storeItem)
        } catch {
            createError = .saveDidFail
        }
    }
    
}

extension CreateItemState {
    
    enum Error: Swift.Error {
        
        case saveDidFail
        
    }
    
}
