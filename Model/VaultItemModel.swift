import Combine
import Foundation

class VaultItemModel: ObservableObject {
    
    @Published var state: State
    
    private let context: VaultItemModelContext
    
    init(context: VaultItemModelContext) {
        let model = context.vaultItemLoadingModel()
        
        self.state = .loading(model)
        self.context = context
        
        model.event
            .map { event in
                switch event {
                case .loaded(let vaultItem):
                    let model = self.context.vaultItemLoadedModel(vaultItem: vaultItem)
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
