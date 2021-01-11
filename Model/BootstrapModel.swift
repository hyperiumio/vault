import Combine
import Crypto
import Foundation
import Preferences
import Storage

protocol BootstrapModelRepresentable: ObservableObject, Identifiable {
    
    var didBootstrap: AnyPublisher<BootstrapState, Never> { get }
    var status: BootstrapStatus { get }
    
    func load()
    
}

enum BootstrapState {
    
    case setup
    case locked(store: Store)
    
}

enum BootstrapStatus {
    
    case initialized
    case loading
    case loadingFailed
    case loaded
    
}

class BootstrapModel: BootstrapModelRepresentable {
    
    @Published private(set) var status = BootstrapStatus.initialized
    
    let containerDirectory: URL
    let preferences: Preferences
    
    var didBootstrap: AnyPublisher<BootstrapState, Never> { didBootstrapSubject.eraseToAnyPublisher() }
    
    private let didBootstrapSubject = PassthroughSubject<BootstrapState, Never>()
    private var vaultLocationSubscription: AnyCancellable?
    
    init(containerDirectory: URL, preferences: Preferences) {
        self.containerDirectory = containerDirectory
        self.preferences = preferences
    }
    
    func load() {
        status = .loading
        
        guard let activeStoreID = preferences.value.activeStoreID else {
            didBootstrapSubject.send(.setup)
            return
        }
        
        vaultLocationSubscription = Store.load(from: containerDirectory, matching: activeStoreID)
            .map { store in
                store.map(BootstrapState.locked) ?? BootstrapState.setup
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .loaded
                case .failure:
                    self.status = .loadingFailed
                }
            } receiveValue: { [didBootstrapSubject] initialAppState in
                didBootstrapSubject.send(initialAppState)
            }
    }
    
}

#if DEBUG
class BootstrapModelStub: BootstrapModelRepresentable {
    
    @Published var status: BootstrapStatus
    
    var didBootstrap: AnyPublisher<BootstrapState, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(status: BootstrapStatus) {
        self.status = status
    }
    
    func load() {}
    
}
#endif
