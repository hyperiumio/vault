import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol BootstrapModelRepresentable: ObservableObject, Identifiable {
    
    var didBootstrap: AnyPublisher<BootstrapInitialState, Never> { get }
    var status: BootstrapStatus { get }
    
    func load()
    
}

enum BootstrapInitialState {
    
    case setup
    case locked(vaultID: UUID)
    
}

enum BootstrapStatus {
    
    case initialized
    case loading
    case loadingFailed
    case loaded
    
}

class BootstrapModel: BootstrapModelRepresentable {
    
    @Published private(set) var status = BootstrapStatus.initialized
    
    let preferences: Preferences
    
    var didBootstrap: AnyPublisher<BootstrapInitialState, Never> { didBootstrapSubject.eraseToAnyPublisher() }
    
    private let didBootstrapSubject = PassthroughSubject<BootstrapInitialState, Never>()
    private var vaultLocationSubscription: AnyCancellable?
    
    init(preferences: Preferences) {
        self.preferences = preferences
    }
    
    func load() {
        status = .loading
        
        guard let applicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            status = .loadingFailed
            return
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            status = .loadingFailed
            return
        }
        
        let vaultContainerDirectory = applicationSupportDirectory.appendingPathComponent(bundleIdentifier, isDirectory: true).appendingPathComponent("vaults", isDirectory: true)
        
        guard let activeVaultIdentifier = preferences.value.activeVaultIdentifier else {
            didBootstrapSubject.send(.setup)
            return
        }
        
        vaultLocationSubscription = Vault.vaultExists(with: activeVaultIdentifier, in: vaultContainerDirectory)
            .map { vaultExists in
                vaultExists ? .locked(vaultID: activeVaultIdentifier) : .setup
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
    
    var didBootstrap: AnyPublisher<BootstrapInitialState, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(status: BootstrapStatus) {
        self.status = status
    }
    
    func load() {}
    
}
#endif
