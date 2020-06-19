import Combine
import Crypto
import Foundation
import  Store

class ContentModel: ObservableObject {
    
    @Published private(set) var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    private let context: ContentModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(setupWithVaultDirectory vaultDirectory: URL, context: ContentModelContext) {
        let model = context.setupModel(vaultDirectory: vaultDirectory)
        self.state = .setup(model)
        self.context = context
        context.responder = self
        
        setupStateTransitions()
    }
    
    init(lockedWithVaultLocation vaultLocation: Vault<SecureDataCryptor>.Location, context: ContentModelContext) {
        let model = context.lockedModel(vaultLocation: vaultLocation)
        self.state = .locked(model)
        self.context = context
        context.responder = self
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .setup(let model):
            stateTransitionSubscription = model.didCreateVault
                .receive(on: DispatchQueue.main)
                .sink { [weak self] vault in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(vault: vault)
                    self.state = .unlocked(model)
                }
        case .locked(let model):
            stateTransitionSubscription = model.didOpenVault
                .receive(on: DispatchQueue.main)
                .sink { [weak self] vault in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(vault: vault)
                    self.state = .unlocked(model)
                }
        case .unlocked:
            stateTransitionSubscription = nil
            return
        }
    }
    
}

extension ContentModel: ContentModelContextResponder {
    
    var isLockable: Bool {
        switch state {
        case .setup, .locked:
            return false
        case .unlocked:
            return true
        }
    }
    
    func lock() {
        switch state {
        case .unlocked(let model):
            let model = context.lockedModel(vaultLocation: model.vaultLocation)
            state = .locked(model)
        case .setup, .locked:
           return
        }
    }
    
}

extension ContentModel {
    
    enum State {
        
        case setup(SetupModel)
        case locked(LockedModel)
        case unlocked(UnlockedModel)
        
    }
    
}
