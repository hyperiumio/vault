import Foundation
import Model
import Sort

@MainActor
class StoreItemDetailState: ObservableObject {
    
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

extension StoreItemDetailState: CollationElement {
    
    nonisolated var sectionKey: String {
        let firstCharacter = storeItemInfo.name.prefix(1)
        return String(firstCharacter)
    }
    
    nonisolated static func < (lhs: StoreItemDetailState, rhs: StoreItemDetailState) -> Bool {
        lhs.storeItemInfo.name < rhs.storeItemInfo.name
    }
    
    nonisolated static func == (lhs: StoreItemDetailState, rhs: StoreItemDetailState) -> Bool {
        lhs.storeItemInfo.name == rhs.storeItemInfo.name
    }
    
}

extension StoreItemDetailState: Identifiable {
    
    nonisolated var id: UUID {
        storeItemInfo.id
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

