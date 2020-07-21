import Combine
import Crypto
import Foundation
import Preferences
import Store

class BootstrapModel: ObservableObject {
    
    @Published private(set) var status = Status.none
    
    let preferencesManager: PreferencesManager
    
    var didBootstrap: AnyPublisher<InitialAppState, Never> { didBootstrapSubject.eraseToAnyPublisher() }
    
    private let didBootstrapSubject = PassthroughSubject<InitialAppState, Never>()
    private var vaultLocationSubscription: AnyCancellable?
    
    init(preferencesManager: PreferencesManager) {
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
        let vaultDirectory = applicationSupportDirectory.appendingPathComponent(bundleIdentifier, isDirectory: true).appendingPathComponent("vaults", isDirectory: true)
        
        guard let activeVaultIdentifier = preferencesManager.preferences.activeVaultIdentifier else {
            let setup = InitialAppState.setup(vaultDirectory)
            didBootstrapSubject.send(setup)
            return
        }
        
        vaultLocationSubscription = Vault<SecureDataCryptor>.vaultLocation(for: activeVaultIdentifier, inDirectory: vaultDirectory)
            .map { vaultLocation in
                if let vaultLocation = vaultLocation {
                    return .locked(vaultLocation)
                } else {
                    return .setup(vaultDirectory)
                }
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

extension BootstrapModel {
    
    enum Status {
        
        case none
        case loading
        case loadingDidFail
        
    }
    
    enum InitialAppState {
        
        case setup(URL)
        case locked(VaultLocation)
        
    }
    
}
