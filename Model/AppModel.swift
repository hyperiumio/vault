import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol AppModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    typealias State = AppState<BootstrapModel, SetupModel, MainModel>
    
    var state: State { get }
    
}

protocol AppModelDependency {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    func bootstrapModel() -> BootstrapModel
    func setupModel() -> SetupModel
    func mainModel(vaultID: UUID) -> MainModel
    func mainModel(vault: Vault) -> MainModel
    
}

enum AppState<BootstrapModel, SetupModel, MainModel> {
    
    case bootstrap(BootstrapModel)
    case setup(SetupModel)
    case main(MainModel)
    
}

class AppModel<Dependency: AppModelDependency>: AppModelRepresentable {
    
    typealias BootstrapModel = Dependency.BootstrapModel
    typealias SetupModel = Dependency.SetupModel
    typealias MainModel = Dependency.MainModel
    
    @Published private(set) var state: State
    
    init(_ dependency: Dependency) {
        
        func statePublisher(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .bootstrap(let model):
                return model.didBootstrap
                    .map { appState in
                        switch appState {
                        case .setup:
                            let model = dependency.setupModel()
                            return .setup(model)
                        case .locked(let vaultID):
                            let model = dependency.mainModel(vaultID: vaultID)
                            return .main(model)
                        }
                    }
                    .eraseToAnyPublisher()
            case .setup(let model):
                return model.done
                    .map(dependency.mainModel)
                    .map(State.main)
                    .eraseToAnyPublisher()
            case .main:
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
        }
        
        let bootstrapModel = dependency.bootstrapModel()
        self.state = .bootstrap(bootstrapModel)
        
        statePublisher(from: state)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        bootstrapModel.load()
    }
    
}

#if DEBUG
class AppModelStub: AppModelRepresentable {
    
    typealias BootstrapModel = BootstrapModelStub
    typealias SetupModel = SetupModelStub
    typealias MainModel = MainModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() {}
    
}
#endif
