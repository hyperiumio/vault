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
    
    func lockedModel(vaultID: UUID) -> LockedModel
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
    
    convenience init(dependency: Dependency, vault: Vault) {
        let unlockedModel = dependency.unlockedModel(vault: vault)
        let state = State.unlocked(model: unlockedModel)
        
        self.init(dependency: dependency, state: state)
    }
    
    convenience init(dependency: Dependency, vaultID: UUID) {
        let lockedModel = dependency.lockedModel(vaultID: vaultID)
        let state = State.locked(model: lockedModel, userBiometricUnlock: true)
        
        self.init(dependency: dependency, state: state)
    }
    
    private init(dependency: Dependency, state: State) {
        
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
                        let model = dependency.lockedModel(vaultID: model.vaultID)
                        return .locked(model: model, userBiometricUnlock: enableBiometricUnlock)
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        self.state = state
        
        statePublisher(from: state)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .assign(to: &$state)
    }
    
}

#if DEBUG
class MainModelStub: MainModelRepresentable {
    
    typealias LockedModel = LockedModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() {}
    
}
#endif
