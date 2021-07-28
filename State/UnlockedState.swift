import Common
import Foundation
import Model
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.empty
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    
    private let yield = AsyncValue<Void>()
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var done: Void {
        get async {
            await yield.value
        }
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let state = CreateItemState(itemType: itemType, dependency: dependency)
        sheet = .createItem(state)
    }
    
}

extension UnlockedState {
    
    typealias Collation = AlphabeticCollation<StoreItemDetailState>
    
    enum Status {
        
        case empty
        case noSearchResult
        case items(Collation)
        
    }
    
    enum Sheet {
        
        case selectItemType
        case createItem(CreateItemState)
        
    }
    
}

extension UnlockedState.Sheet: Identifiable {
    
    var id: String {
        switch self {
        case .selectItemType:
            return "selectItemType"
        case .createItem:
            return "selectItemType"
        }
    }
    
}
