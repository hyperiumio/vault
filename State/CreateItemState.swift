import Event
import Foundation
import Model

@MainActor
class CreateItemState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems = [SecureItemState]()
    @Published private(set) var status = Status.readyToSave
    
    private let service: AppServiceProtocol
    
    init(itemType: SecureItemType, service: AppServiceProtocol) {
        self.primaryItem = SecureItemState(itemType: itemType, service: service)
        self.service = service
    }
    
    func save() {
        guard status == .readyToSave else {
            return
        }
        
        status = .saving
        
        let id = UUID()
        let name = title
        let primaryItem = primaryItem.secureItem
        let secondaryItems = secondaryItems.map(\.secureItem)
        let created = Date.now
        let modified = created
        let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
        
        Task {
            do {
                try await service.save(storeItem)
                status = .didSave
            } catch {
                status = .savingDidFail
            }
        }
    }
    
}

extension CreateItemState {
    
    enum Status {
        
        case readyToSave
        case saving
        case didSave
        case savingDidFail
        
    }
    
}
