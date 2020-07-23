import Combine
import Foundation
import Store

class VaultItemLoadedModel: ObservableObject {
    
    @Published var state: State {
        didSet {
            switch state {
            case .display(let model):
                model.event
                    .map { [context] event in
                        switch event {
                        case .requestsEditMode(let vaultItem):
                            let editModel = context.vaultItemEditModel(vaultItem: vaultItem)
                            return .edit(editModel)
                        }
                    }
                    .receive(on: DispatchQueue.main)
                    .assign(to: &$state)
            case .edit(let model):
                model.event
                    .map { event in
                        switch event {
                        case .done(let vaultItem):
                            let displayModel = VaultItemDisplayModel(vaultItem: vaultItem)
                            return .display(displayModel)
                        }
                    }
                    .receive(on: DispatchQueue.main)
                    .assign(to: &$state)
            }
        }
    }
    
    private let context: VaultItemLoadedModelContext
    
    init(vaultItem: VaultItem, context: VaultItemLoadedModelContext) {
        let model = VaultItemDisplayModel(vaultItem: vaultItem)
         
        self.state = .display(model)
        self.context = context
        
        model.event
            .map { event in
                switch event {
                case .requestsEditMode(let vaultItem):
                    let editModel = context.vaultItemEditModel(vaultItem: vaultItem)
                    return .edit(editModel)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

extension VaultItemLoadedModel {
    
    
    enum State {
        
        case display(VaultItemDisplayModel)
        case edit(VaultItemEditModel)
        
    }
    
}
