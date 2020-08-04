import Combine
import Foundation
import Store

class VaultItemLoadedModel: ObservableObject {
    
    @Published var state: State
    
    init(vaultItem: VaultItem, context: VaultItemLoadedModelContext) {
        let model = VaultItemDisplayModel(vaultItem: vaultItem)
         
        self.state = .display(model)
        
        state.transition(using: context)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap { state in state.transition(using: context) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

extension VaultItemLoadedModel {
    
    
    enum State {
        
        case display(VaultItemDisplayModel)
        case edit(VaultItemEditModel)
        
        func transition(using context: VaultItemLoadedModelContext) -> AnyPublisher<Self, Never> {
            switch self {
            case .display(let model):
                return model.event
                    .map { event in
                        switch event {
                        case .requestsEditMode(let vaultItem):
                            let editModel = context.vaultItemEditModel(vaultItem: vaultItem)
                            return .edit(editModel)
                        }
                    }
                    .eraseToAnyPublisher()
            case .edit(let model):
                return model.event
                    .map { event in
                        switch event {
                        case .done(let vaultItem):
                            let displayModel = VaultItemDisplayModel(vaultItem: vaultItem)
                            return .display(displayModel)
                        }
                    }
                    .eraseToAnyPublisher()
            }
        }
        
    }
    
}
