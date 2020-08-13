import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

class SetupModel: ObservableObject {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = Status.none
    
    var createMasterKeyButtonDisabled: Bool { password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || status == .loading }
    
    var textInputDisabled: Bool { status == .loading }
    
    var event: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let vaultContainerDirectory: URL
    private let preferencesManager: PreferencesManager
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultContainerDirectory: URL, preferencesManager: PreferencesManager) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferencesManager = preferencesManager
        
        Publishers.Merge($password, $repeatedPassword)
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func createMasterKey() {
        guard password == repeatedPassword else {
            status = .passwordMismatch
            return
        }
        guard password.count >= 8 else {
            status = .insecurePassword
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: vaultContainerDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            status = .vaultCreationFailed
            return
        }
        
        status = .loading
        createVaultSubscription = Vault.create(in: vaultContainerDirectory, with: password, using: Cryptor.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .vaultCreationFailed
                }
            } receiveValue: { [preferencesManager, eventSubject] vault in
                preferencesManager.set(activeVaultIdentifier: vault.id)
                
                let event = Event.didSetup(vault, AlphabeticCollation<UnlockedModel.Item>())
                eventSubject.send(event)
            }
    }
    
}

extension SetupModel {
    
    enum Status {
        
        case none
        case loading
        case passwordMismatch
        case insecurePassword
        case vaultCreationFailed
        
    }
    
    enum Event {
        
        case didSetup(Vault, AlphabeticCollation<UnlockedModel.Item>)
        
    }
    
}
