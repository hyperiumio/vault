import Combine
import Crypto
import Foundation
import Preferences
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
    func setupModel(in vaultContainerDirectory: URL) -> SetupModel
    func mainModel(vaultDirectory: URL) -> MainModel
    func mainModel(vaultDirectory: URL, vault: Vault) -> MainModel
    
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
                        case .setup(let vaultContainerDirectory):
                            let model = dependency.setupModel(in: vaultContainerDirectory)
                            return .setup(model)
                        case .locked(let vaultDirectory):
                            let model = dependency.mainModel(vaultDirectory: vaultDirectory)
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
