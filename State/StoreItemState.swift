
import Foundation
import Model

@MainActor
class StoreItemDetailState: ObservableObject{
    
    @Published private(set) var status = Status.initialized
    
    func load() async {
        
    }
    
    func cancelEdit() {
        guard case .edit = status else {
            return
        }
        
        status = .display
    }
    
}

extension StoreItemDetailState {
    
    enum Status {
        
        case initialized
        case loading
        case display
        case edit(StoreItemEditState)
        case loadingFailed
        
    }
    
}

