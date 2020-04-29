import Combine

class VaultItemLoadedModel: ObservableObject {
    
    @Published var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    private var vaultItem: VaultItem
    private let context: VaultItemLoadedModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(vaultItem: VaultItem, context: VaultItemLoadedModelContext) {
        let displayModel = VaultItemDisplayModel(vaultItem: vaultItem)
         
        self.state = .display(displayModel)
        self.vaultItem = vaultItem
        self.context = context
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .display(let model):
            stateTransitionSubscription = model.completion()
                .sink { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    
                    switch completion {
                    case .edit:
                        let editModel = self.context.vaultItemEditModel(vaultItem: self.vaultItem)
                        self.state = .edit(editModel)
                    }
                }
        case .edit(let model):
            stateTransitionSubscription = model.completion()
                .sink { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    
                    if case .saved(let vaultItem) = completion  {
                        self.vaultItem = vaultItem
                    }
                    
                    let displayModel = VaultItemDisplayModel(vaultItem: self.vaultItem)
                    self.state = .display(displayModel)
                }
        }
    }
    
}

extension VaultItemLoadedModel {
    
    
    enum State {
        
        case display(VaultItemDisplayModel)
        case edit(VaultItemEditModel)
        
    }
    
}
