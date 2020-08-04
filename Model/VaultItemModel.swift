import Combine
import Foundation

class VaultItemModel: ObservableObject {
    
    @Published var state: State
    
    init(context: VaultItemModelContext) {
        let model = context.vaultItemLoadingModel()
        
        self.state = .loading(model)
        
        model.event
            .map { event in
                switch event {
                case .loaded(let vaultItem):
                    let model = context.vaultItemLoadedModel(vaultItem: vaultItem)
                    return State.loaded(model)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

extension VaultItemModel {
    
    enum State {
        
        case loading(VaultItemLoadingModel)
        case loaded(VaultItemLoadedModel)
        
    }
    
}
