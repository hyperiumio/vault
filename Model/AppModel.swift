import Combine
import Crypto
import Foundation
import Store
import Preferences
import Sort

protocol AppModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    typealias State = AppState<BootstrapModel, SetupModel, LockedModel, UnlockedModel>
    
    var state: State { get }
    
    func lock()
    
}

protocol AppModelDependency {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    func bootstrapModel() -> BootstrapModel
    func setupModel(in vaultsDirectory: URL) -> SetupModel
    func lockedModel(container: VaultContainer) -> LockedModel
    func unlockedModel(vault: Vault) -> UnlockedModel
    
}

enum AppState<BootstrapModel, SetupModel, LockedModel, UnlockedModel> {
    
    case bootstrap(BootstrapModel)
    case setup(SetupModel)
    case locked(LockedModel)
    case relocked(LockedModel)
    case unlocked(UnlockedModel)
    
}

class AppModel<Dependency: AppModelDependency>: AppModelRepresentable {
    
    typealias BootstrapModel = Dependency.BootstrapModel
    typealias SetupModel = Dependency.SetupModel
    typealias LockedModel = Dependency.LockedModel
    typealias UnlockedModel = Dependency.UnlockedModel
    
    @Published private(set) var state: State
    
    private let dependency: Dependency
    
    init(_ dependency: Dependency) {
        
        func stateEvent(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .bootstrap(let model):
                return model.didBootstrap
                    .map { appState in
                        switch appState {
                        case .setup(let url):
                            return .setup(dependency.setupModel(in: url))
                        case .locked(let container):
                            return .locked(dependency.lockedModel(container: container))
                        }
                    }
                    .eraseToAnyPublisher()
            case .setup(let model):
                return model.done
                    .map(dependency.unlockedModel)
                    .map(State.unlocked)
                    .eraseToAnyPublisher()
            case .locked(let model), .relocked(let model):
                return model.done
                    .map(dependency.unlockedModel)
                    .map(State.unlocked)
                    .eraseToAnyPublisher()
            case .unlocked(let model):
                fatalError()
                /* !!!
                return model.lock
                    .map {
                        dependency.lockedModel(container: model.cont)
                    }
                    .map(State.relocked)
                    .eraseToAnyPublisher() */
            }
        }
        
        let model = dependency.bootstrapModel()
        self.state = .bootstrap(model)
        self.dependency = dependency
        
        stateEvent(from: state)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap(stateEvent)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        model.load()
    }
    
    func lock() {
        guard case .unlocked(let unlockedModel) = state else { return }
        
       // state = .relocked(dependency.lockedModel(container: unlockedModel.container))
    }
    
}
