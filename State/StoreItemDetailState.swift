import Collection
import Foundation
import Model

@MainActor
class StoreItemDetailState: ObservableObject, Identifiable {
    
    @Published private(set) var status: Status
    private let storeItem: StoreItem
    private let service: AppServiceProtocol
    
    init(itemID: UUID, service: AppServiceProtocol) async throws {
        let storeItem = try await service.load(itemID: itemID)
        
        self.status = .display(storeItem)
        self.storeItem = storeItem
        self.service = service
    }
    
    var name: String {
        storeItem.name
    }
    
    var description: String? {
        storeItem.description
    }
    
    var primaryType: SecureItemType {
        storeItem.primaryItem.value.secureItemType
    }
    
    func edit() {
        guard case .display = status else {
            return
        }
        
        let editState = StoreItemEditState(editing: storeItem, service: service)
        status = .edit(editState)
    }
    
    func cancelEdit() {
        guard case let .edit(storeItemEditState) = status else {
            return
        }
        
        status = .display(storeItemEditState.editedStoreItem)
    }
    
}

extension StoreItemDetailState {
    
    enum Status {
        
        case display(StoreItem)
        case edit(StoreItemEditState)
        
    }
    
    enum Input {
        
        case edit
        case cancel
        
    }
    
}

