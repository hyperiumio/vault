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
    
}

protocol AppModelDependency {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    func bootstrapModel() -> BootstrapModel
    func setupModel(url: URL) -> SetupModel
    func lockedModel(url: URL) -> LockedModel
    func unlockedModel(store: VaultItemStore) -> UnlockedModel
    
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
    
    init(_ dependency: Dependency) {
        
        func stateEvent(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .bootstrap(let model):
                return model.didBootstrap
                    .map { appState in
                        switch appState {
                        case .setup(let url):
                            return .setup(dependency.setupModel(url: url))
                        case .locked(let url):
                            return .locked(dependency.lockedModel(url: url))
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
                return model.lock
                    .map(dependency.lockedModel)
                    .map(State.relocked)
                    .eraseToAnyPublisher()
            }
        }
        
        let model = dependency.bootstrapModel()
        self.state = .bootstrap(model)
        
        stateEvent(from: state)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap(stateEvent)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        model.load()
    }
    
}
