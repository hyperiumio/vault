import Combine
import Store
import Crypto
import Foundation
import Sort

protocol QuickAccessModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype QuickAccessLockedModel: QuickAccessLockedModelRepresentable
    associatedtype QuickAccessUnlockedModel: QuickAccessUnlockedModelRepresentable
    
    typealias State = QuickAccessModelState<QuickAccessLockedModel, QuickAccessUnlockedModel>
    
    var state: State { get }
    var done: AnyPublisher<LoginCredential, Never> { get }
    
}

protocol QuickAccessModelDependency {
    
    associatedtype QuickAccessLockedModel: QuickAccessLockedModelRepresentable
    associatedtype QuickAccessUnlockedModel: QuickAccessUnlockedModelRepresentable
    
    func quickAccessLockedModel(vaultID: UUID) -> QuickAccessLockedModel
    func quickAccessUnlockedModel(vaultItems: [VaultItemInfo: [LoginItem]]) -> QuickAccessUnlockedModel
    
}

enum QuickAccessModelState<Locked, Unlocked> {
    
    case locked(Locked)
    case unlocked(Unlocked)
    
}

class QuickAccessModel<Dependency>: QuickAccessModelRepresentable where Dependency: QuickAccessModelDependency {
    
    typealias QuickAccessLockedModel = Dependency.QuickAccessLockedModel
    typealias QuickAccessUnlockedModel = Dependency.QuickAccessUnlockedModel
    
    @Published var state: State
    
    var done: AnyPublisher<LoginCredential, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<LoginCredential, Never>()
    private var selectedSubscription: AnyCancellable?
    
    init(dependency: Dependency, vaultID: UUID) {
        let lockedModel = dependency.quickAccessLockedModel(vaultID: vaultID)
        
        self.state = .locked(lockedModel)
        
        lockedModel.done
            .map { vaultItems in
                let unlockedModel = dependency.quickAccessUnlockedModel(vaultItems: vaultItems)
                self.selectedSubscription = unlockedModel.selected.subscribe(self.doneSubject)
                
                return unlockedModel
            }
            .map(QuickAccessModelState.unlocked)
            .assign(to: &$state)
    }
    
}
