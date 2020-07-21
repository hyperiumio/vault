import Combine
import Crypto
import Foundation
import Store

class AppModel: ObservableObject {
    
    @Published private(set) var state: State
    
    private let context: AppModelContext
    
    init(context: AppModelContext) {
        let model = context.bootstrapModel()
        self.state = .bootstrap(model)
        self.context = context
        
        state.transition(using: context, lockVault: lock)
            .receive(on: DispatchQueue.main)
            .assign(to: $state)
        
        $state
            .flatMap { state in state.transition(using: context, lockVault: self.lock) }
            .receive(on: DispatchQueue.main)
            .assign(to: $state)
        
        model.load()
    }
    
    func lock() {
        switch state {
        case .bootstrap, .setup, .locked:
            return
        case .unlocked(let unlockedModel):
            let lockedModel = context.lockedModel(vaultLocation: unlockedModel.vault.location)
            self.state = .locked(lockedModel)
        }
    }
    
}

extension AppModel {
    
    enum State {
        
        case bootstrap(BootstrapModel)
        case setup(SetupModel)
        case locked(LockedModel)
        case unlocked(UnlockedModel)
        
        func transition(using context: AppModelContext, lockVault: @escaping () -> Void) -> AnyPublisher<Self, Never> {
            switch self {
            case .bootstrap(let model):
                return model.didBootstrap
                    .map { appState in
                        switch appState {
                        case .setup(let url):
                            let model = context.setupModel(vaultDirectory: url)
                            return .setup(model)
                        case .locked(let location):
                            let model = context.lockedModel(vaultLocation: location)
                            return .locked(model)
                        }
                    }
                    .eraseToAnyPublisher()
            case .setup(let model):
                return model.didCreateVault
                    .map { vault in
                        let model = context.unlockedModel(vault: vault, lockVault: lockVault)
                        model.load()
                        return .unlocked(model)
                    }
                    .eraseToAnyPublisher()
            case .locked(let model):
                return model.didOpenVault
                    .map { vault in
                        let model = context.unlockedModel(vault: vault, lockVault: lockVault)
                        model.load()
                        return .unlocked(model)
                    }
                    .eraseToAnyPublisher()
            case .unlocked:
                return Empty(completeImmediately: false)
                    .eraseToAnyPublisher()
            }
        }
        
    }
    
}
