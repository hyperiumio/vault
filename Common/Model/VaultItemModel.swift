import Combine
import Foundation

class VaultItemModel: ObservableObject {
    
    @Published var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    private let context: VaultItemModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(context: VaultItemModelContext) {
        let model = context.vaultItemLoadingModel()
        
        self.state = .loading(model)
        self.context = context
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .loading(let model):
            stateTransitionSubscription = model.completion()
                .sink { [weak self] vaultItem in
                    guard let self = self else {
                        return
                    }
                    
                    let loadedModelContext = self.context.vaultItemLoadedModelContext()
                    let model = VaultItemLoadedModel(vaultItem: vaultItem, context: loadedModelContext)
                    self.state = State.loaded(model)
                }
        case .loaded:
            stateTransitionSubscription = nil
        }
    }
    
}

extension VaultItemModel {
    
    enum State {
        
        case loading(VaultItemLoadingModel)
        case loaded(VaultItemLoadedModel)
        
    }
    
}
