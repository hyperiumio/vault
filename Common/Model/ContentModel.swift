import Combine
import CryptoKit
import Foundation

class ContentModel: ObservableObject {
    
    @Published private(set) var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    private let context: ContentModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(initialState: InitialState, context: ContentModelContext) {
        switch initialState {
        case .setup:
            let model = context.setupModel()
            self.state = .setup(model)
        case .locked:
            let model = context.lockedModel()
            self.state = .locked(model)
        }
        
        self.context = context
        context.responder = self
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .setup(let model):
            stateTransitionSubscription = model.didCreateMasterKey
                .receive(on: DispatchQueue.main)
                .sink { [weak self] masterKey in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(masterKey: masterKey)
                    self.state = .unlocked(model)
                }
        case .locked(let model):
            stateTransitionSubscription = model.didDecryptMasterKey
                .receive(on: DispatchQueue.main)
                .sink { [weak self] masterKey in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(masterKey: masterKey)
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
        let model = context.lockedModel()
        state = .locked(model)
    }
    
}

extension ContentModel {
    
    enum InitialState {
        
        case setup
        case locked
        
    }
    
    enum State {
        
        case setup(SetupModel)
        case locked(LockedModel)
        case unlocked(UnlockedModel)
        
    }
    
}
