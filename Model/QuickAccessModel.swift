import Combine
import Storage
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
    
    func quickAccessLockedModel(store: Store) -> QuickAccessLockedModel
    func quickAccessUnlockedModel(vaultItems: [StoreItemInfo: [LoginItem]]) -> QuickAccessUnlockedModel
    
}

enum QuickAccessModelState<Locked, Unlocked> {
    
    case loading
    case loadingFailed
    case locked(Locked, Store)
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
    
    init(dependency: Dependency, containerDirectory: URL, storeID: UUID) {
        
        func statePublisher(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .loading:
                return Store.load(from: containerDirectory, matching: storeID)
                    .tryMap { store -> Store in
                        guard let store = store else {
                            throw NSError()
                        }
                        
                        return store
                    }
                    .map { store in
                        let model = dependency.quickAccessLockedModel(store: store)
                        return .locked(model, store)
                    }
                    .replaceError(with: .loadingFailed)
                    .eraseToAnyPublisher()
            case .loadingFailed:
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            case .locked(let model, let store):
                let encryptedItemIndexLoaded = store.loadItems() { context -> (Store.ItemLocator, SecureDataHeader, SecureDataMessage) in
                    let header = try SecureDataHeader { range in
                        try context.bytes(in: range)
                    }
                    let nonceDataRange = header.elements[.infoIndex].nonceRange
                    let ciphertextRange = header.elements[.infoIndex].ciphertextRange
                    let nonce = try context.bytes(in: nonceDataRange)
                    let ciphertext = try context.bytes(in: ciphertextRange)
                    let tag = header.elements[.infoIndex].tag
                    let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
                    return (context.itemLocator, header, message)
                }
                .assertNoFailure()
                
                return Publishers.CombineLatest(encryptedItemIndexLoaded, model.done)
                    .map { _, _ in
                        dependency.quickAccessUnlockedModel(vaultItems: [:]) // needs fix
                    }
                    .map(State.unlocked)
                    .replaceError(with: .loadingFailed)
                    .eraseToAnyPublisher()
            case .unlocked:
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
        }
        
        self.state = .loading
        
        statePublisher(from: state)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .assign(to: &$state)
    }
    
}

private extension Int {
    
    static let infoIndex = 0
    
}
