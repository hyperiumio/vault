import Foundation
import Model

@MainActor
protocol StoreItemDetailDependency {
    
    var storeItem: StoreItem { get async throws }
    var storeItemEditDependency: StoreItemEditDependency { get }
}

@MainActor
class StoreItemDetailState: ObservableObject{
    
    @Published private(set) var status = Status.initialized
    private let dependency: StoreItemDetailDependency
    
    init(dependency: StoreItemDetailDependency) {
        self.dependency = dependency
    }
    
    func load() async {
        do {
            let storeItem = try await dependency.storeItem
            status = .display(storeItem)
        } catch {
            status = .loadingFailed
        }
    }
    
    func edit() {
        guard case .display(let storeItem) = status else {
            return
        }
        
        let editState = StoreItemEditState(dependency: dependency.storeItemEditDependency, editing: storeItem)
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
    
    typealias SecureItem = Model.SecureItem
    
}

