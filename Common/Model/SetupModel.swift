import Combine
import Crypto
import Foundation
import Preferences
import Store

class SetupModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = nil
        }
    }
    
    @Published var repeatedPassword = "" {
        didSet {
            message = nil
        }
    }
    
    @Published private(set) var isLoading = false
    @Published private(set) var message: Message?
    
    var createMasterKeyButtonDisabled: Bool { password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || isLoading }
    
    var textInputDisabled: Bool { isLoading }
    
    let didCreateVault = PassthroughSubject<Vault<SecureDataCryptor>, Never>()
    
    private let vaultDirectory: URL
    private let preferencesManager: PreferencesManager
    
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultDirectory: URL, preferencesManager: PreferencesManager) {
        self.vaultDirectory = vaultDirectory
        self.preferencesManager = preferencesManager
    }
    
    func createMasterKey() {
        message = nil
        
        guard password == repeatedPassword else {
            message = .passwordMismatch
            return
        }
        
        isLoading = true
        
        createVaultSubscription = Vault<SecureDataCryptor>.create(inDirectory: vaultDirectory, using: password)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success(let vault):
                    self.preferencesManager.set(activeVaultIdentifier: vault.id)
                    self.didCreateVault.send(vault)
                case .failure:
                    self.message = .vaultCreationFailed
                }
            }
    }
    
}

extension SetupModel {
    
    enum Message {
        
        case passwordMismatch
        case vaultCreationFailed
        
    }
    
}
