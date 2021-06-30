import Foundation
import Model

@MainActor
class StoreItemLoadingState: ObservableObject{
    
    @Published private(set) var status = Status.initialized
    
    private let itemLocator: StoreItemLocator
    private let store: Store
    
    init(itemLocator: StoreItemLocator, store: Store) {
        self.itemLocator = itemLocator
        self.store = store
    }
    
    func load() async {
        status = .loading
        /*
        do {
            let storeItem = try await store.loadItem(itemLocator: itemLocator)
            let state = StoreItemDetailState(storeItem: storeItem)
            status = .loaded(state)
        } catch {
            status = .loadingFailed
        }
         */
    }
    
}

extension StoreItemLoadingState {
    
    enum Status {
        
        case initialized
        case loading
        case loadingFailed
        case loaded(StoreItemDetailState)
        
    }
    
}

