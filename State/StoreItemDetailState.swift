import Foundation
import Model

@MainActor
class StoreItemDetailState: ObservableObject, Identifiable {
    
    @Published private(set) var status = Status.initialized
    
    private let storeItemInfo: StoreItemInfo
    private let dependency: Dependency
    
    init(storeItemInfo: StoreItemInfo, dependency: Dependency) {
        self.storeItemInfo = storeItemInfo
        self.dependency = dependency
    }
    
    var name: String {
        storeItemInfo.name
    }
    
    var description: String? {
        storeItemInfo.description
    }
    
    var primaryType: SecureItemType {
        storeItemInfo.primaryType
    }
    
    func load() async {
        guard case .initialized = status else {
            return
        }
        
        status = .loading
        
        do {
            let storeItem = try await dependency.storeItemService.load(itemID: storeItemInfo.id)
            status = .display(storeItem)
        } catch {
            status = .loadingFailed
        }
    }
    
    func edit() {
        guard case .display(let storeItem) = status else {
            return
        }
        
        let editState = StoreItemEditState(editing: storeItem, dependency: dependency)
        status = .edit(editState)
    }
    
    func cancelEdit() {
        guard case .edit(let storeItemEditState) = status else {
            return
        }
        
        status = .display(storeItemEditState.editedStoreItem)
    }
    
}

extension StoreItemDetailState {
    
    enum Status {
        
        case initialized
        case loading
        case display(StoreItem)
        case edit(StoreItemEditState)
        case loadingFailed
        
    }
    
}

