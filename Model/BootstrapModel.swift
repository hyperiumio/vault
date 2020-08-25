import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol BootstrapModelRepresentable: ObservableObject, Identifiable {
    
    typealias InitialState = BootstrapInitialState
    typealias Status = BootstrapStatus
    
    var didBootstrap: AnyPublisher<InitialState, Never> { get }
    var status: BootstrapStatus { get }
    
    init(preferencesManager: PreferencesManager)
    
    func load()
    
}

enum BootstrapInitialState {
    
    case setup(URL)
    case locked(URL)
    
}

enum BootstrapStatus {
    
    case none
    case loading
    case loadingDidFail
    
}

class BootstrapModel: BootstrapModelRepresentable {
    
    @Published private(set) var status = Status.none
    
    let preferencesManager: PreferencesManager
    
    var didBootstrap: AnyPublisher<InitialState, Never> { didBootstrapSubject.eraseToAnyPublisher() }
    
    private let didBootstrapSubject = PassthroughSubject<InitialState, Never>()
    private var vaultLocationSubscription: AnyCancellable?
    
    required init(preferencesManager: PreferencesManager) {
        self.preferencesManager = preferencesManager
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
        
        guard let activeVaultIdentifier = preferencesManager.preferences.activeVaultIdentifier else {
            let setup = InitialState.setup(vaultContainerDirectory)
            didBootstrapSubject.send(setup)
            return
        }
        
        vaultLocationSubscription = Vault.vaultDirectory(in: vaultContainerDirectory, with: activeVaultIdentifier)
            .map { vaultDirectory in
                vaultDirectory.map(InitialState.locked) ?? InitialState.setup(vaultContainerDirectory)
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
