import Foundation
import Model
import Shim
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.emptyStore
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    
    private let dependency: Dependency
    private var lockContinuation: CheckedContinuation<Void, Never>?
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        Task {
            do {
                for await _ in await dependency.storeItemService.didChange {
                    let states = try await dependency.storeItemService.loadInfos().map { info in
                        StoreItemDetailState(storeItemInfo: info, dependency: dependency)
                    }
                    let collation = Collation(from: states) { state in
                        state.name
                    }
                    status = .items(collation)
                }
            }
            catch {
                
            }
        }
    }
    
    var locked: Void {
        get async {
            await withCheckedContinuation { continuation in
                lockContinuation = continuation
            }
        }
    }
    
    func showSettings() {
        let state = SettingsState(dependency: dependency)
        sheet = .settings(state)
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let state = CreateItemState(itemType: itemType, dependency: dependency)
        sheet = .createItem(state)
    }
    
    func lock() {
        lockContinuation?.resume()
    }
    
}

extension UnlockedState {
    
    typealias Collation = AlphabeticCollation<StoreItemDetailState>
    
    enum Status {
        
        case emptyStore
        case noSearchResults
        case items(Collation)
        
    }
    
    enum Sheet {
        
        case settings(SettingsState)
        case createItem(CreateItemState)
        
    }
    
}

extension UnlockedState.Sheet: Identifiable {
    
    var id: String {
        switch self {
        case .settings:
            return "Settings"
        case .createItem:
            return "CreateItem"
        }
    }
    
}
