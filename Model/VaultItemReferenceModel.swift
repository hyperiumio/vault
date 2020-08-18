import Combine
import Foundation
import Store

class VaultItemReferenceModel: ObservableObject {
    
    @Published var state: State
    
    init(vault: Vault, itemID: UUID) {
        let model = VaultItemLoadingModel(vault: vault, itemID: itemID)
        
        self.state = .loading(model)
        
        model.event
            .map { event in
                switch event {
                case .loaded(let vaultItem):
                    let model = VaultItemModel(vault: vault, vaultItem: vaultItem)
                    return State.loaded(model)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

extension VaultItemReferenceModel {
    
    enum State {
        
        case loading(VaultItemLoadingModel)
        case loaded(VaultItemModel)
        
    }
    
}
