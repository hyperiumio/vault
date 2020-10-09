import Combine
import Foundation

protocol MainModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    typealias State = MainModelState<LockedModel, UnlockedModel>
    
    var state: State { get }
    
}

protocol MainModelDependency {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    func lockedModel(vaultDirectory: URL) -> LockedModel
    func unlockedModel(vault: Vault) -> UnlockedModel
    
}

enum MainModelState<Locked, Unlocked> {
    
    case locked(model: Locked, userBiometricUnlock: Bool)
    case unlocked(model: Unlocked)
    
}

class MainModel<Dependency>: MainModelRepresentable where Dependency: MainModelDependency {
    
    typealias LockedModel = Dependency.LockedModel
    typealias UnlockedModel = Dependency.UnlockedModel
    
    @Published var state: State
    
    private let dependency: Dependency
    private let vaultDirectory: URL
    
    init(dependency: Dependency, vaultDirectory: URL, vault: Vault? = nil) {
        
        func statePublisher(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .locked(let model, _):
                return model.done
                    .map(dependency.unlockedModel)
                    .map(MainModelState.unlocked)
                    .eraseToAnyPublisher()
            case .unlocked(let model):
                return model.lockRequest
                    .map { enableBiometricUnlock in
                        let model = dependency.lockedModel(vaultDirectory: vaultDirectory)
                        return .locked(model: model, userBiometricUnlock: enableBiometricUnlock)
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        if let vault = vault {
            let model = dependency.unlockedModel(vault: vault)
            self.state = .unlocked(model: model)
        } else {
            let model = dependency.lockedModel(vaultDirectory: vaultDirectory)
            self.state = .locked(model: model, userBiometricUnlock: true)
        }
        
        self.dependency = dependency
        self.vaultDirectory = vaultDirectory
        
        statePublisher(from: state)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}
