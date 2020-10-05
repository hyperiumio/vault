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
    
    case setup(vaultContainerDirectory: URL)
    case locked(vaultDirectory: URL)
    
}

enum BootstrapStatus {
    
    case none
    case loading
    case loadingDidFail
    
}

class BootstrapModel: BootstrapModelRepresentable {
    
    @Published private(set) var status = BootstrapStatus.none
    
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
            status = .loadingDidFail
            return
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            status = .loadingDidFail
            return
        }
        
        let vaultContainerDirectory = applicationSupportDirectory.appendingPathComponent(bundleIdentifier, isDirectory: true).appendingPathComponent("vaults", isDirectory: true)
        
        guard let activeVaultIdentifier = preferences.value.activeVaultIdentifier else {
            let setup = BootstrapInitialState.setup(vaultContainerDirectory: vaultContainerDirectory)
            didBootstrapSubject.send(setup)
            return
        }
        
        vaultLocationSubscription = Vault.directory(in: vaultContainerDirectory, with: activeVaultIdentifier)
            .map { vaultDirectory in
                vaultDirectory.map { vaultDirectory in
                    .locked(vaultDirectory: vaultDirectory)
                } ?? .setup(vaultContainerDirectory: vaultContainerDirectory)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .loadingDidFail
                }
            } receiveValue: { [didBootstrapSubject] initialAppState in
                didBootstrapSubject.send(initialAppState)
            }
    }
    
}
