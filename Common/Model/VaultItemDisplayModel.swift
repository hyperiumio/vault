import Combine
import Foundation

class VaultItemDisplayModel: ObservableObject {
    
    @Published var state: State
    
    private var vaultItemLoadingSubscription: AnyCancellable?
    
    init(loadOperation: LoadVaultItemOperation) {
        let model = VaultItemLoadingModel(loadOperation: loadOperation)
        self.state = .loading(model)
        
        vaultItemLoadingSubscription = model.completion()
            .map { vaultItem in
                let model = VaultItemLoadedModel(vaultItem: vaultItem)
                return State.loaded(model)
            }
            .assign(to: \.state, on: self)
    }
    
}

extension VaultItemDisplayModel {
    
    enum State {
        
        case loading(VaultItemLoadingModel)
        case loaded(VaultItemLoadedModel)
        
    }
    
}
