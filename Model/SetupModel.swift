import Combine
import Crypto
import Foundation
import Preferences
import Store

class SetupModel: ObservableObject {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = Status.none
    
    var createMasterKeyButtonDisabled: Bool { password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || status == .loading }
    
    var textInputDisabled: Bool { status == .loading }
    
    var didCreateVault: AnyPublisher<Vault<SecureDataCryptor>, Never> { didCreateVaultSubject.eraseToAnyPublisher() }
    
    private let didCreateVaultSubject = PassthroughSubject<Vault<SecureDataCryptor>, Never>()
    private let vaultDirectory: URL
    private let preferencesManager: PreferencesManager
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultDirectory: URL, preferencesManager: PreferencesManager) {
        self.vaultDirectory = vaultDirectory
        self.preferencesManager = preferencesManager
        
        Publishers.Merge($password, $repeatedPassword)
            .map { _ in .none }
            .assign(to: $status)
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
        
        status = .loading
        createVaultSubscription = Vault<SecureDataCryptor>.create(inDirectory: vaultDirectory, using: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .vaultCreationFailed
                }
            } receiveValue: { [preferencesManager, didCreateVaultSubject] vault in
                preferencesManager.set(activeVaultIdentifier: vault.id)
                didCreateVaultSubject.send(vault)
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
    
}
